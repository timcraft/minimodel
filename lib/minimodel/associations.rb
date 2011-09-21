require 'active_support/inflector'

class MiniModel
  class HasManyAssociation
    def initialize(owner, association_name, options = {})
      @owner, @association_name, @options = owner, association_name, options
    end

    def each(&block)
      collection.each(&block)
    end

    def size
      arel_model? ? collection.size : collection.length
    end

    include Enumerable

    private

    def collection
      @collection ||= begin
        owner_id = @owner.send(@owner.class.primary_key)

        if arel_model?
          target_model.where(foreign_key => owner_id)
        else
          target_model.all.select { |object| object.send(foreign_key) == owner_id }
        end
      end
    end

    def arel_model?
      target_model.respond_to?(:where)
    end

    def foreign_key
      @foreign_key ||= '%s_%s' % [@owner.class.name.demodulize.underscore, @owner.class.primary_key]
    end

    def target_model
      @target_model ||= @association_name.to_s.classify.constantize
    end
  end

  module AssociationClassMethods
    def has_many(association_name, options = {})
      define_method(association_name) do
        HasManyAssociation.new(self, association_name, options)
      end
    end
  end

  extend AssociationClassMethods
end
