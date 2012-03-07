require 'spec_helper'

describe Petition do
  describe "validation" do
    it "should validate presence of title" do
      should validate_presence_of(:title)
    end

    it "should validate presence of description" do
      should validate_presence_of(:description)
    end

    it "should validate presence of resulting_actions" do
      should validate_presence_of(:resulting_actions)
    end

    it "should validate presence of end_on" do
      should validate_presence_of(:end_on)
    end

    it "should validate presence of person_id" do
      should validate_presence_of(:person_id)
    end

    it "should validate presence of signature_needed" do
      should validate_presence_of(:signature_needed)
    end
    
    it "should validate numericality of signature_needed to be greater than 0" do
      should validate_numericality_of(:signature_needed)
    end
  end
  describe "Associations" do
    it "should belong_to conversation" do
      should belong_to(:conversation)
    end
    it "should have many signatures" do
      should have_many(:signatures).dependent(:destroy)
    end
    it "should have many signers" do
      should have_many(:signers).through(:signatures)
    end
    
  end
end