require "spec_helper"

describe Mongoid::Attributes do

  context "when persisting nil attributes" do

    before do
      @person = Person.create(:score => nil, :ssn => "555-66-7777")
    end

    after do
      Person.delete_all
    end

    it "the field should exist with a nil value" do
      from_db = Person.find(@person.id)
      from_db.attributes.has_key?(:score).should be_true
    end

  end

end
