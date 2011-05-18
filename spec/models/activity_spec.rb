require 'spec_helper'

describe Activity do

  context "Validation" do

    let(:params) do
      Factory.attributes_for(:activity)
    end

    it "Requires item_id" do
      params.delete(:item_id)
      Activity.new(params).should_not be_valid
    end

    it "Requires item_type" do
      params.delete(:item_type)
      Activity.new(params).should_not be_valid
    end

    it "Requires item_created_at" do
      params.delete(:item_created_at)
      Activity.new(params).should_not be_valid
    end

    it "Validates the item exists" do
      params.delete(:item_created_at)
      Activity.new(params).should_not be_valid
    end

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
