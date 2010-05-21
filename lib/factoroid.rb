module Factoroid
  def self.included(base) # :nodoc:
    base.extend ClassMethods
  end

  module ClassMethods #:nodoc:

    def generate(overrides = {}, &block)
      instance = Factory.build(name.underscore, overrides)
      instance.save
      yield(instance) if block_given?
      instance
    end

    def generate!(overrides = {}, &block)
      instance = Factory.create(name.underscore, overrides)
      yield(instance) if block_given?
      instance
    end

    def spawn(overrides = {}, &block)
      instance = Factory.build(name.underscore, overrides)
      yield(instance) if block_given?
      instance
    end
  end
end
