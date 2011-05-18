require 'spec_helper'

describe Activity do

  context "Validation" do

    it "Requires item_id" do
    end

    it "Requires item_type"
    it "Requires item_created_at"
    it "Validates the item exists"
  end

  context "Creating new activity records" do
    it "Creates a new activity from valid observerd object"
    it "Returns true when new activity record is successfully created"
    it "Returns false if observed object was nil"
    it "Returns false if activity fails validation"
    it "Does not create a new acivity object on failed validation"
  end

  context "Removing activity records" do
    it "Deletes object when matching activity is found"
    it "Returns true when matching activity is found"
    it "Returns false when matching activity is not found"
  end

end
