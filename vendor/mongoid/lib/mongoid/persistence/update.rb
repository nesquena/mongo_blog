# encoding: utf-8
module Mongoid #:nodoc:
  module Persistence #:nodoc:
    # Update is a persistence command responsible for taking a document that
    # has already been saved to the database and saving it, depending on
    # whether or not the document has been modified.
    #
    # Before persisting the command will check via dirty attributes if the
    # document has changed, if not, it will simply return true. If it has it
    # will go through the validation steps, run callbacks, and set the changed
    # fields atomically on the document. The underlying query resembles the
    # following MongoDB query:
    #
    #   collection.update(
    #     { "_id" : 1,
    #     { "$set" : { "field" : "value" },
    #     false,
    #     false
    #   );
    #
    # For embedded documents it will use the positional locator:
    #
    #   collection.update(
    #     { "_id" : 1, "addresses._id" : 2 },
    #     { "$set" : { "addresses.$.field" : "value" },
    #     false,
    #     false
    #   );
    #
    class Update < Command
      # Persist the document that is to be updated to the database. This will
      # only write changed fields via MongoDB's $set modifier operation.
      #
      # Example:
      #
      # <tt>Update.persist</tt>
      #
      # Returns:
      #
      # +true+ or +false+, depending on validation.
      def persist
        return false if validate && !@document.valid?
        @document.run_callbacks(:before_save)
        @document.run_callbacks(:before_update)
        if update
          @document.move_changes
          @document.run_callbacks(:after_save)
          @document.run_callbacks(:after_update)
        else
          return false
        end; true
      end

      protected
      # Update the document in the database atomically.
      def update
        @collection.update(@document._selector, { "$set" => @document.setters }, @options.merge(:multi => false))
      end
    end
  end
end
