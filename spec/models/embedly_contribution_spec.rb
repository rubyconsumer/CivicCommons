require 'spec_helper'

describe EmbedlyContribution do

  before(:each) do
    @person = Factory.build(:registered_user)
    @embedly_contribution = Factory.attributes_for(:embedly_contribution)
    @embedly_contribution[:person] = @person
  end

  it "Should require url" do
    @embedly_contribution[:url] = nil
    EmbedlyContribution.new(@embedly_contribution).should_not be_valid
  end

  it "Should require embedly_type" do
    @embedly_contribution[:embedly_type] = nil
    EmbedlyContribution.new(@embedly_contribution).should_not be_valid
  end

  it "Should require embedly_code" do
    @embedly_contribution[:embedly_code] = nil
    EmbedlyContribution.new(@embedly_contribution).should_not be_valid
  end

end
