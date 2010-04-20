# encoding: utf-8
module Mongoid #:nodoc
  module Components #:nodoc
    extend ActiveSupport::Concern
    included do
      # All modules that a +Document+ is composed of are defined in this
      # module, to keep the document class from getting too cluttered.
      include Mongoid::Associations
      include Mongoid::Attributes
      include Mongoid::Callbacks
      include Mongoid::Collections
      include Mongoid::Dirty
      include Mongoid::Extras
      include Mongoid::Fields
      include Mongoid::Indexes
      include Mongoid::Matchers
      include Mongoid::Memoization
      include Mongoid::Observable
      include Mongoid::Paths
      include Mongoid::Persistence
      include Mongoid::State
      include Validatable
      extend Mongoid::Finders
      extend Mongoid::NamedScope
    end
  end
end
