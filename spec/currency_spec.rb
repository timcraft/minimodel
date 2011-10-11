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

  it 'should respond_to?(:code) and respond_to?(:name)' do
    @euro.respond_to?(:code).must_equal true
    @euro.respond_to?(:name).must_equal true
  end

  it 'should have attribute reader methods' do
    @euro.code.must_equal 'EUR'
    @euro.name.must_equal 'Euro'
  end

  describe '#eql?' do
    describe 'when passed the same currency object' do
      it 'should return true' do
        @euro.eql?(@euro).must_equal true
        @euro.eql?(Currency.new(code: 'EUR', name: 'Euro')).must_equal true
      end
    end

    describe 'when passed a different currency object' do
      it 'should return false' do
        @euro.eql?(Currency.new(code: 'GBP', name: 'Pound sterling')).must_equal false
      end
    end
  end

  describe '#to_hash' do
    it 'should return a hash containing the object attributes' do
      @euro.to_hash.must_be_kind_of Hash
      @euro.to_hash.must_equal code: 'EUR', name: 'Euro'
    end
  end

  describe '#to_json' do
    it 'should return a string containing a JSON object' do
      @euro.to_json.must_equal '{"code":"EUR","name":"Euro"}'
    end
  end

  describe '#read_attribute' do
    it 'should return the value corresponding to the given attribute name' do
      @euro.read_attribute(:code).must_equal 'EUR'
      @euro.read_attribute(:name).must_equal 'Euro'
    end
  end
end

describe Currency do
  describe '#all' do
    it 'should return an array containing currency objects' do
      Currency.all.must_be_kind_of Array
      Currency.all.all? { |object| object.must_be_kind_of Currency }
    end
  end

  describe '#primary_key' do
    it 'should return the primary key specified using #indexed_by' do
      Currency.primary_key.must_equal :code
    end
  end

  describe '#count' do
    it 'should return the total number of currencies defined' do
      Currency.count.must_equal 5
    end
  end

  describe '#find' do
    describe 'when passed a valid currency code' do
      it 'should return the correct currency' do
        currency = Currency.find('EUR')

        currency.must_be_kind_of Currency
        currency.code.must_equal 'EUR'
        currency.name.must_equal 'Euro'
      end
    end

    describe 'when passed an invalid currency code' do
      it 'should return nil' do
        Currency.find('FOO').must_be_nil
      end
    end
  end

  describe '#insert' do
    it 'should raise an error when passed a key that already exists' do
      proc { Currency.insert(code: 'EUR', name: 'Euro') }.must_raise MiniModel::DuplicateKeyError
    end
  end
end
