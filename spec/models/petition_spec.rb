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
  describe "signed_by?" do
    def given_petition_signed_by_person
      @petition = Factory.create(:petition)
      @person = @petition.signers.first
    end
    it "should correctly confirm if a petition is signed by someone" do
      given_petition_signed_by_person
      @petition.signed_by?(@person).should be_true
    end
    it "should not confirm if petition is not signed by person" do
      given_petition_signed_by_person
      @person2 = Factory.create(:person)
      @petition.signed_by?(@person2).should be_false
    end
  end
  describe "sign" do
    def given_un_signed_petition
      @petition = Factory.create(:unsigned_petition)
      @person = Factory.create(:person)
    end
    it "should sign the person" do
      given_un_signed_petition
      @petition.signers.should == []
      @petition.sign(@person)
      @petition.signers.include?(@person).should be_true
    end
  end
  describe "votable?" do
    it "should be votable if end_on in the future" do
      @petition = Factory.build(:petition, :end_on => 3.days.from_now)
      @petition.should be_votable
    end
    it "should be votable if end_on is not today" do
      @petition = Factory.build(:petition, :end_on => 1.days.from_now)
      @petition.should be_votable
    end
    it "should not be votable if end_on is yesterday" do
      @petition = Factory.build(:petition, :end_on => 1.days.ago)
      @petition.should_not be_votable
    end
    it "should not be votable if end_on is today" do
      @petition = Factory.build(:petition, :end_on => Date.today)
      @petition.should_not be_votable
    end
  end
end