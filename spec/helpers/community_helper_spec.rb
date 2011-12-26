require 'spec_helper'

describe CommunityHelper do

  context "community_site_filter_link" do
    describe "when an order is found" do
      it "should display the correct link with 'active' css class" do
        helper.stub!(:params).and_return({})
        @order = 'newest-member'
        helper.community_site_filter_link('newest-member').should == "<a href=\"/community\" class=\"active\" id=\"newest-member\">Newest Members</a>"
      end
    end

    describe "when an order is not found" do
      it "should display the correct link with no 'active' css class" do
        helper.stub!(:params).and_return({})
        @order = 'other-order'
        helper.community_site_filter_link('newest-member').should == "<a href=\"/community?order=newest-member\" id=\"newest-member\">Newest Members</a>"
      end
    end

    it "should preserve the page parameter" do
      helper.stub!(:params).and_return({:page=>2})
      @order = 'newest-member'
      helper.community_site_filter_link('newest-member').should == "<a href=\"/community?page=2\" class=\"active\" id=\"newest-member\">Newest Members</a>"
    end
  end

  context "display_name" do
    it 'should display the last name first and the first name last' do
      user = Factory.build(:normal_person, :first_name => "Tom", :last_name => "Kat")

      helper.display_name(user).should == "Kat, Tom"
    end

    it "should display the full name if the first name is missing" do
      user = Factory.build(:normal_person, :first_name => nil, :last_name => "Kat")

      helper.display_name(user).should == "Kat"
    end

    it "should display the full name if the last name is missing" do
      user = Factory.build(:normal_person, :first_name => "Tom", :last_name => nil)

      helper.display_name(user).should == "Tom"
    end
  end
end
