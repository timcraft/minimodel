require 'minimodel'
require 'json'

class Currency < MiniModel
  indexed_by :code

  load_from 'spec/currency_data.yml'

  insert code: 'INR', name: 'Indian rupee'
  insert code: 'JPY', name: 'Japanese yen'
end

RSpec.describe 'Currency' do
  before do
    @euro = Currency.new(code: 'EUR', name: 'Euro')
  end

  it 'responds to code and name methods' do
    expect(@euro.respond_to?(:code)).to eq(true)
    expect(@euro.respond_to?(:name)).to eq(true)
  end

  it 'provides attribute reader methods' do
    expect(@euro.code).to eq('EUR')
    expect(@euro.name).to eq('Euro')
  end

  describe '#eql?' do
    it 'returns true when passed a currency object with the same attributes' do
      expect(@euro.eql?(@euro)).to eq(true)
      expect(@euro.eql?(Currency.new(code: 'EUR', name: 'Euro'))).to eq(true)
    end

    it 'returns false when given a currency object with a different code' do
      expect(@euro.eql?(Currency.new(code: 'GBP', name: 'Pound sterling'))).to eq(false)
    end
  end

  describe '#to_hash' do
    it 'returns a hash containing the object attributes' do
      expect(@euro.to_hash).to eq({code: 'EUR', name: 'Euro'})
    end
  end

  describe '#to_json' do
    it 'returns a string containing the object attributes encoded as json' do
      output = @euro.to_json

      expect(output).to match(/\{.+?\}/)
      expect(output).to match(/"code":"EUR"/)
      expect(output).to match(/"name":"Euro"/)
    end
  end

  describe '#read_attribute' do
    it 'returns the value corresponding to the given attribute name' do
      expect(@euro.read_attribute(:code)).to eq('EUR')
      expect(@euro.read_attribute(:name)).to eq('Euro')
    end
  end

  describe '.all' do
    it 'returns an array containing currency objects' do
      expect(Currency.all).to be_an(Array)

      Currency.all.each do |object|
        expect(object).to be_a(Currency)
      end
    end
  end

  describe '.keys' do
    it 'returns an array containing all the primary keys' do
      expect(Currency.keys).to eq(%w(EUR GBP USD INR JPY))
    end
  end

  describe '.options' do
    it 'returns a hash mapping the given text attribute to primary keys' do
      options = {
        'Euro' => 'EUR',
        'Pound sterling' => 'GBP',
        'United States dollar' => 'USD',
        'Indian rupee' => 'INR',
        'Japanese yen' => 'JPY'
      }

      expect(Currency.options(:name)).to eq(options)
    end
  end

  describe '.primary_key' do
    it 'returns the name of the primary key attribute' do
      expect(Currency.primary_key).to eq(:code)
    end
  end

  describe '.count' do
    it 'returns the total number of currencies' do
      expect(Currency.count).to eq(5)
    end
  end

  describe '.find' do
    it 'returns the correct currency object' do
      currency = Currency.find('EUR')

      expect(currency).to be_kind_of(Currency)
      expect(currency.code).to eq('EUR')
      expect(currency.name).to eq('Euro')
    end

    it 'raises an error if the currency cannot be found' do
      expect { Currency.find('FOO') }.to raise_error(KeyError) # 1.9
    end

    it 'yields if the currency cannot be found and the caller supplies a block' do
      expect(Currency.find('FOO') { nil }).to be_nil
    end
  end

  describe '.insert' do
    it 'raises an error when passed a key that already exists' do
      expect { Currency.insert(code: 'EUR', name: 'Euro') }.to raise_error(MiniModel::DuplicateKeyError)
    end
  end
end
