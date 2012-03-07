require 'spec_helper'

describe PetitionSignature do
  describe "validation" do
    it "should validate presence of petition_id" do
      should validate_presence_of :petition_id
    end
    it "should validate presence of person_id" do
      should validate_presence_of :person_id
    end
  end
  describe "Associations" do
    it "should belong_to petition" do
      should belong_to(:petition)
    end
    it "should belong_to person" do
      should belong_to(:person)
    end
  end
end