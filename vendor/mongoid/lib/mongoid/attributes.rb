# encoding: utf-8
module Mongoid #:nodoc:
  module Attributes
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        extend ClassMethods
      end
    end
    module InstanceMethods
      # Get the id associated with this object. This will pull the _id value out
      # of the attributes +Hash+.
      def id
        @attributes["_id"]
      end

      # Set the id of the +Document+ to a new one.
      def id=(new_id)
        @attributes["_id"] = new_id
      end

      alias :_id :id
      alias :_id= :id=

      # Used for allowing accessor methods for dynamic attributes.
      def method_missing(name, *args)
        attr = name.to_s
        return super unless @attributes.has_key?(attr.reader)
        if attr.writer?
          # "args.size > 1" allows to simulate 1.8 behavior of "*args"
          @attributes[attr.reader] = (args.size > 1) ? args : args.first
        else
          @attributes[attr.reader]
        end
      end

      # Process the provided attributes casting them to their proper values if a
      # field exists for them on the +Document+. This will be limited to only the
      # attributes provided in the suppied +Hash+ so that no extra nil values get
      # put into the document's attributes.
      def process(attrs = nil)
        (attrs || {}).each_pair do |key, value|
          if set_allowed?(key)
            @attributes[key.to_s] = value
          elsif write_allowed?(key)
            send("#{key}=", value)
          end
        end
        setup_modifications
      end

      # Read a value from the +Document+ attributes. If the value does not exist
      # it will return nil.
      #
      # Options:
      #
      # name: The name of the attribute to get.
      #
      # Example:
      #
      # <tt>person.read_attribute(:title)</tt>
      def read_attribute(name)
        access = name.to_s
        fields[access].get(@attributes[access])
      end

      # Remove a value from the +Document+ attributes. If the value does not exist
      # it will fail gracefully.
      #
      # Options:
      #
      # name: The name of the attribute to remove.
      #
      # Example:
      #
      # <tt>person.remove_attribute(:title)</tt>
      def remove_attribute(name)
        access = name.to_s
        modify(access, @attributes.delete(access), nil)
      end

      # Returns the object type. This corresponds to the name of the class that
      # this +Document+ is, which is used in determining the class to
      # instantiate in various cases.
      def _type
        @attributes["_type"]
      end

      # Set the type of the +Document+. This should be the name of the class.
      def _type=(new_type)
        @attributes["_type"] = new_type
      end

      # Write a single attribute to the +Document+ attribute +Hash+. This will
      # also fire the before and after update callbacks, and perform any
      # necessary typecasting.
      #
      # Options:
      #
      # name: The name of the attribute to update.
      # value: The value to set for the attribute.
      #
      # Example:
      #
      # <tt>person.write_attribute(:title, "Mr.")</tt>
      #
      # This will also cause the observing +Document+ to notify it's parent if
      # there is any.
      def write_attribute(name, value)
        access = name.to_s
        modify(access, @attributes[access], fields[access].set(value))
        notify if !id.blank? && new_record?
      end

      # Writes the supplied attributes +Hash+ to the +Document+. This will only
      # overwrite existing attributes if they are present in the new +Hash+, all
      # others will be preserved.
      #
      # Options:
      #
      # attrs: The +Hash+ of new attributes to set on the +Document+
      #
      # Example:
      #
      # <tt>person.write_attributes(:title => "Mr.")</tt>
      #
      # This will also cause the observing +Document+ to notify it's parent if
      # there is any.
      def write_attributes(attrs = nil)
        process(attrs || {})
        identified = !id.blank?
        if new_record? && !identified
          identify; notify
        end
      end
      alias :attributes= write_attributes

      protected
      # Return true is dynamic field setting is enabled.
      def set_allowed?(key)
        Mongoid.allow_dynamic_fields && !respond_to?("#{key}=")
      end

      # Used when supplying a :reject_if block as an option to
      # accepts_nested_attributes_for
      def reject(attributes, options)
        rejector = options[:reject_if]
        if rejector
          attributes.delete_if do |key, value|
            rejector.call(value)
          end
        end
      end

      # Return true if writing to the given field is allowed
      def write_allowed?(key)
        name = key.to_s
        existing = fields[name]
        return true unless existing
        existing.accessible?
      end
    end

    module ClassMethods
      # Defines attribute setters for the associations specified by the names.
      # This will work for a has one or has many association.
      #
      # Example:
      #
      #   class Person
      #     include Mongoid::Document
      #     embeds_one :name
      #     embeds_many :addresses
      #
      #     accepts_nested_attributes_for :name, :addresses
      #   end
      def accepts_nested_attributes_for(*args)
        associations = args.flatten
        options = associations.last.is_a?(Hash) ? associations.pop : {}
        associations.each do |name|
          define_method("#{name}_attributes=") do |attrs|
            reject(attrs, options)
            association = send(name)
            if association
              observe(association, true)
              association.nested_build(attrs)
            else
              send("build_#{name}", attrs)
            end
          end
        end
      end
    end
  end
end
