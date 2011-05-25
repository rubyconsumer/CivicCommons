require 'spec_helper'

describe EmbedlyContribution do

  context "validation" do

    before(:each) do
      @person = Factory.build(:registered_user)
      @embedly_contribution = Factory.attributes_for(:embedly_contribution)
      @embedly_contribution[:person] = @person
    end

    it "requires url" do
      @embedly_contribution[:url] = nil
      EmbedlyContribution.new(@embedly_contribution).should_not be_valid
    end

    it "requires embedly_type" do
      @embedly_contribution[:embedly_type] = nil
      EmbedlyContribution.new(@embedly_contribution).should_not be_valid
    end

    it "requires embedly_code" do
      @embedly_contribution[:embedly_code] = nil
      EmbedlyContribution.new(@embedly_contribution).should_not be_valid
    end

  end

  context "base_url" do

    let(:embedly) do
      Factory.build(:embedly_contribution)
    end

    it "returns blank when url is blank" do
      embedly.url = nil
      embedly.base_url.should be_blank
      embedly.url = ''
      embedly.base_url.should be_blank
    end

    it "returns the host valid base url when url is valid" do
      embedly.url = 'http://localhost:3000/issues/more-about-the-civic-commons'
      embedly.base_url.should == 'http://localhost:3000'
      embedly.url = 'http://www.youtube.com/watch?v=QCvYTijYDfE'
      embedly.base_url.should == 'http://www.youtube.com'
    end

  end

end
