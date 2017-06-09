require 'minitest/autorun'
require 'minimodel'
require 'json'

class Currency < MiniModel
  indexed_by :code

  load_from 'spec/currency_data.yml'

  insert code: 'INR', name: 'Indian rupee'
  insert code: 'JPY', name: 'Japanese yen'
end

describe 'A currency object' do
  before do
    @euro = Currency.new(code: 'EUR', name: 'Euro')
  end

  it 'responds to code and name methods' do
    @euro.respond_to?(:code).must_equal(true)
    @euro.respond_to?(:name).must_equal(true)
  end

  it 'provides attribute reader methods' do
    @euro.code.must_equal('EUR')
    @euro.name.must_equal('Euro')
  end

  describe 'eql query method' do
    it 'returns true when passed a currency object with the same attributes' do
      @euro.eql?(@euro).must_equal(true)
      @euro.eql?(Currency.new(code: 'EUR', name: 'Euro')).must_equal(true)
    end

    it 'returns false when given a currency object with a different code' do
      @euro.eql?(Currency.new(code: 'GBP', name: 'Pound sterling')).must_equal(false)
    end
  end

  describe 'to_hash method' do
    it 'returns a hash containing the object attributes' do
      @euro.to_hash.must_equal({code: 'EUR', name: 'Euro'})
    end
  end

  describe 'to_json method' do
    it 'returns a string containing the object attributes encoded as json' do
      output = @euro.to_json
      output.must_match(/\{.+?\}/)
      output.must_match(/"code":"EUR"/)
      output.must_match(/"name":"Euro"/)
    end
  end

  describe 'read_attribute method' do
    it 'returns the value corresponding to the given attribute name' do
      @euro.read_attribute(:code).must_equal('EUR')
      @euro.read_attribute(:name).must_equal('Euro')
    end
  end
end

describe 'Currency' do
  describe 'all class method' do
    it 'returns an array containing currency objects' do
      Currency.all.must_be_kind_of(Array)
      Currency.all.each { |object| object.must_be_kind_of(Currency) }
    end
  end

  describe 'keys class method' do
    it 'returns an array containing all the primary keys' do
      Currency.keys.must_equal(%w(EUR GBP USD INR JPY))
    end
  end

  describe 'options class method' do
    it 'returns a hash mapping the given text attribute to primary keys' do
      options = {
        'Euro' => 'EUR',
        'Pound sterling' => 'GBP',
        'United States dollar' => 'USD',
        'Indian rupee' => 'INR',
        'Japanese yen' => 'JPY'
      }

      Currency.options(:name).must_equal(options)
    end
  end

  describe 'primary_key class method' do
    it 'returns the name of the primary key attribute' do
      Currency.primary_key.must_equal(:code)
    end
  end

  describe 'count class method' do
    it 'returns the total number of currencies' do
      Currency.count.must_equal(5)
    end
  end

  describe 'find class method' do
    it 'returns the correct currency object' do
      currency = Currency.find('EUR')

      currency.must_be_kind_of(Currency)
      currency.code.must_equal('EUR')
      currency.name.must_equal('Euro')
    end

    it 'raises an error if the currency cannot be found' do
      proc { Currency.find('FOO') }.must_raise(KeyError) # 1.9
    end

    it 'yields if the currency cannot be found and the caller supplies a block' do
      Currency.find('FOO') { nil }.must_be_nil
    end
  end

  describe 'insert class method' do
    it 'raises an error when passed a key that already exists' do
      proc { Currency.insert(code: 'EUR', name: 'Euro') }.must_raise(MiniModel::DuplicateKeyError)
    end
  end
end
