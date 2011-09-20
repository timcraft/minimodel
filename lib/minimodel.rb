require 'yaml'

class MiniModel
  def initialize(attributes)
    @attributes = attributes.to_hash
  end

  def hash
    @attributes.hash
  end

  def eql?(object)
    object.class == self.class && object.hash == self.hash
  end

  def to_hash
    @attributes
  end

  def method_missing(symbol, *args, &block)
    if @attributes.has_key?(symbol) && args.empty? && block.nil?
      return @attributes[symbol]
    else
      super symbol, *args, &block
    end
  end

  class DuplicateKeyError < StandardError
  end

  module ClassMethods
    def all
      index.values
    end

    def count
      index.length
    end

    def primary_key
      @primary_key ||= :id
    end

    def indexed_by(primary_key)
      @primary_key = primary_key
    end

    def insert(*args)
      object = new(*args)

      pkey = object.send(primary_key)

      if index.has_key?(pkey)
        raise DuplicateKeyError
      end

      index[pkey] = object
    end

    def find(key)
      index[key]
    end

    def load_from(path)
      YAML.load_file(path).each do |key, attrs|
        insert symbolize_keys(attrs, primary_key => key)
      end
    end

    private

    def symbolize_keys(hash, initial_value=nil)
      hash.inject(initial_value) do |tmp, (k, v)|
        tmp.merge(k.to_sym => v)
      end
    end

    def index
      @index ||= {}
    end
  end

  extend ClassMethods
end
