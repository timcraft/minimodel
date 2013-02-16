require 'yaml'

class MiniModel
  if defined?(id)
    undef_method :id
  end

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

  def to_json
    @attributes.to_json
  end

  def read_attribute(name)
    @attributes[name]
  end

  def method_missing(symbol, *args, &block)
    if @attributes.has_key?(symbol) && args.empty? && block.nil?
      return @attributes[symbol]
    else
      super symbol, *args, &block
    end
  end

  def respond_to_missing?(symbol, include_private = false)
    @attributes.has_key?(symbol)
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
      @primary_key
    end

    def indexed_by(primary_key, options = {})
      @primary_key = primary_key

      @auto_increment = options[:auto_increment] ? 1 : nil
    end

    def keys
      all.map(&primary_key)
    end

    def insert(attributes)
      unless @auto_increment.nil?
        attributes[primary_key] = @auto_increment

        @auto_increment += 1
      end

      object = new(attributes)

      pkey = object.send(primary_key)

      if index.has_key?(pkey)
        raise DuplicateKeyError
      end

      index[pkey] = object
    end

    def find(primary_key, &block)
      index.fetch(primary_key, &block)
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
