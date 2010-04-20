require "spec_helper"

describe Mongoid::Dirty do

  describe "#attribute_change" do

    context "when the attribute has changed" do

      before do
        @person = Person.new(:title => "Grand Poobah")
        @person.title = "Captain Obvious"
      end

      it "returns an array of the old value and new value" do
        @person.attribute_change("title").should ==
          [ "Grand Poobah", "Captain Obvious" ]
      end

      it "allows access via (attribute)_change" do
        @person.title_change.should ==
          [ "Grand Poobah", "Captain Obvious" ]
      end
    end

    context "when the attribute has not changed" do

      before do
        @person = Person.new(:title => "Grand Poobah")
      end

      it "returns an empty array" do
        @person.attribute_change("title").should be_nil
      end
    end

    context "when the attribute has been set with the same value" do

      before do
        @person = Person.new(:title => "Grand Poobah")
        @person.title = "Grand Poobah"
      end

      it "returns an empty array" do
        @person.attribute_change("title").should be_nil
      end
    end

    context "when the attribute has been removed" do
      before do
        @person = Person.new(:title => "Grand Poobah")
        @person.remove_attribute(:title)
      end

      it "returns an array of the old value and nil" do
        @person.attribute_change("title").should ==
          [ "Grand Poobah", nil ]
      end
    end
  end

  describe "#attribute_changed?" do

    context "when the attribute has changed" do

      before do
        @person = Person.new(:title => "Grand Poobah")
        @person.title = "Captain Obvious"
      end

      it "returns true" do
        @person.attribute_changed?("title").should == true
      end

      it "allows access via (attribute)_changed?" do
        @person.title_changed?.should == true
      end
    end

    context "when the attribute has not changed" do

      before do
        @person = Person.new(:title => "Grand Poobah")
      end

      it "returns false" do
        @person.attribute_changed?("title").should == false
      end
    end

    context "when the attribute has been removed" do
      before do
        @person = Person.new(:title => "Grand Poobah")
        @person.remove_attribute(:title)
      end

      it "returns true" do
        @person.attribute_changed?("title").should be_true
      end
    end
  end

  describe "#attribute_was" do

    context "when the attribute has changed" do

      before do
        @person = Person.new(:title => "Grand Poobah")
        @person.title = "Captain Obvious"
      end

      it "returns the old value" do
        @person.attribute_was("title").should == "Grand Poobah"
      end

      it "allows access via (attribute)_was" do
        @person.title_was.should == "Grand Poobah"
      end
    end

    context "when the attribute has not changed" do

      before do
        @person = Person.new(:title => "Grand Poobah")
      end

      it "returns nil" do
        @person.attribute_was("title").should be_nil
      end
    end

    context "when the attribute has been removed" do
      before do
        @person = Person.new(:title => "Grand Poobah")
        @person.remove_attribute(:title)
      end

      it "returns the old value" do
        @person.attribute_was("title").should == "Grand Poobah"
      end
    end

  end

  describe "#changed" do

    context "when the document has changed" do

      before do
        @person = Person.new(:title => "Grand Poobah")
        @person.title = "Captain Obvious"
      end

      it "returns an array of changed field names" do
        @person.changed.should == [ "title" ]
      end
    end

    context "when the document has not changed" do

      before do
        @person = Person.new(:title => "Grand Poobah")
      end

      it "returns an empty array" do
        @person.changed.should == []
      end
    end

    context "when the attribute has been removed" do
      before do
        @person = Person.new(:title => "Grand Poobah")
        @person.remove_attribute(:title)
      end

      it "returns an array of changed field names" do
        @person.changed.should == [ "title" ]
      end
    end
  end

  describe "#changed?" do

    context "when the document has changed" do

      before do
        @person = Person.new(:title => "Grand Poobah")
        @person.title = "Captain Obvious"
      end

      it "returns true" do
        @person.should be_changed
      end
    end

    context "when the document has not changed" do

      before do
        @person = Person.new(:title => "Grand Poobah")
      end

      it "returns false" do
        @person.should_not be_changed
      end
    end

    context "when the attribute has been removed" do
      before do
        @person = Person.new(:title => "Grand Poobah")
        @person.remove_attribute(:title)
      end

      it "returns true" do
        @person.should be_changed
      end
    end

  end

  describe "#changes" do

    context "when the document has changed" do

      before do
        @person = Person.new(:title => "Grand Poobah")
        @person.title = "Captain Obvious"
      end

      it "returns a hash of changes" do
        @person.changes.should ==
          { "title" => [ "Grand Poobah", "Captain Obvious" ] }
      end
    end

    context "when the document has not changed" do

      before do
        @person = Person.new(:title => "Grand Poobah")
      end

      it "returns an empty hash" do
        @person.changes.should == {}
      end
    end

    context "when the attribute has been removed" do
      before do
        @person = Person.new(:title => "Grand Poobah")
        @person.remove_attribute(:title)
      end

      it "returns a hash of changes" do
        @person.changes.should == 
          { "title" => [ "Grand Poobah", nil ] }
      end
    end

  end

  describe "#setters" do

    context "when the document has changed" do

      context "when the document is a root document" do

        before do
          @person = Person.new(:title => "Grand Poobah")
          @person.title = "Captain Obvious"
        end

        it "returns a hash of field names and new values" do
          @person.setters.should ==
            { "title" => "Captain Obvious" }
        end
      end

      context "when the document is embedded" do

        before do
          @person = Person.new(:title => "Grand Poobah")
          @address = Address.new(:street => "Oxford St")
          @person.addresses << @address
          @person.instance_variable_set(:@new_record, false)
          @address.instance_variable_set(:@new_record, false)
          @address.street = "Bond St"
        end

        it "returns a hash of field names and new values" do
          @address.setters.should ==
            { "addresses.0.street" => "Bond St" }
        end
      end
    end

    context "when the document has not changed" do

      before do
        @person = Person.new(:title => "Grand Poobah")
      end

      it "returns an empty hash" do
        @person.setters.should == {}
      end
    end
  end

  describe "#previous_changes" do

    before do
      @person = Person.new(:title => "Grand Poobah")
      @person.title = "Captain Obvious"
    end

    context "when the document has been saved" do

      before do
        @person.collection.expects(:insert).returns(true)
        @person.save!
      end

      it "returns the changes before the save" do
        @person.previous_changes["title"].should ==
          [ "Grand Poobah", "Captain Obvious" ]
      end
    end

    context "when the document has not been saved" do

      it "returns an empty hash" do
        @person.previous_changes.should == {}
      end
    end
  end

  describe "#reset_attribute!" do

    context "when the attribute has changed" do

      before do
        @person = Person.new(:title => "Grand Poobah")
        @person.title = "Captain Obvious"
      end

      it "resets the value to the original" do
        @person.reset_attribute!("title")
        @person.title.should == "Grand Poobah"
      end

      it "allows access via reset_(attribute)!" do
        @person.reset_title!
        @person.title.should == "Grand Poobah"
      end

      it "removes the field from the changes" do
        @person.reset_title!
        @person.changed.should == []
      end
    end

    context "when the attribute has not changed" do

      before do
        @person = Person.new(:title => "Grand Poobah")
      end

      it "does nothing" do
        @person.reset_attribute!("title")
        @person.title.should == "Grand Poobah"
      end
    end
  end
end
