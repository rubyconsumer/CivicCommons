require 'spec_helper'

describe Action do
  describe "validation" do
    it {should validate_presence_of :conversation_id}
    it {should validate_presence_of :actionable_id}
    it {should validate_presence_of :actionable_type}
  end
  describe "Associations" do
    it {should belong_to :conversation}
    it {should belong_to :actionable}
    it {should have_and_belong_to_many :reflections}
  end
  describe "delegation" do
    it "should delegate participants to actionable" do
      @petition = Factory.create(:petition)
      @action = @petition.action
      @action.participants.should == @petition.participants
    end
  end
end