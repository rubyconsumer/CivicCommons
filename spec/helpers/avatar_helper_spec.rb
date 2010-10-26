require 'spec_helper'

describe AvatarHelper do
  before(:all) do
    @me = Factory.build(:normal_person, :first_name => "My", :last_name => "Self")
    @me.id = 1
    @registered_user = Factory.build(:registered_user, :first_name => "Someone", :last_name => "Else", :people_aggregator_id => 13)
    @registered_user.id = 13
  end
  
  context "link to profile" do
    it "should link to my private page" do
      helper.stub(:current_person).and_return(@me)
      helper.should_receive(:pa_link).with('me').and_return("http://pa.com/me?pa_token=sometoken")
      
      helper.link_to_profile(@me) do
        "blah"
      end.should == <<-EOHTML
    <a href="http://pa.com/me?pa_token=sometoken" title="My Self">
      blah
    </a>
EOHTML
    end
    
    it "should like to go to a persons public page" do
      helper.stub(:current_person).and_return(@me)
      helper.should_receive(:pa_link).with('user/13').and_return("http://pa.com/user/13?pa_token=sometoken")
      
      helper.link_to_profile(@registered_user) do
        "blah"
      end.should == <<-EOHTML
    <a href="http://pa.com/user/13?pa_token=sometoken" title="Someone Else">
      blah
    </a>
EOHTML
    end
  end
  
  context "profile image" do
    it "should display a profile image with the default size" do
      @me.avatar.url(:standard).gsub(/\?\d*/, '').should == "http://s3.amazonaws.com/cc-dev/avatars/1/standard/test_image.jpg"
      
      @me.avatar.stub(:url).and_return("http://avatar_url")
      helper.profile_image(@me).should == "    <img src=\"http://avatar_url\" alt=\"My Self\" height=\"20\" width=\"20\" title=\"My Self\"/>\n"
    end

    it "should display a profile image with a size of 80" do
      @me.avatar.stub(:url).and_return("http://avatar_url")
      helper.profile_image(@me, 80).should == "    <img src=\"http://avatar_url\" alt=\"My Self\" height=\"80\" width=\"80\" title=\"My Self\"/>\n"
    end
  end
  
  context "avatar profile" do
    context "should display a profile image with a default size of 20" do
      it "when there is no PA ID" do
        @me.avatar.stub(:url).and_return("http://avatar_url")
        helper.avatar_profile(@me).should ==  "    <img src=\"http://avatar_url\" alt=\"My Self\" height=\"20\" width=\"20\" title=\"My Self\"/>\n"
      end
    
      it "and a link when there is a PA ID" do
        helper.stub(:current_person).and_return(@me)
        helper.should_receive(:pa_link).with('user/13').and_return("http://pa.com/user/13?pa_token=sometoken")
        @registered_user.avatar.stub(:url).and_return("http://avatar_url")
        helper.avatar_profile(@registered_user).should ==  <<-EOHTML
    <a href="http://pa.com/user/13?pa_token=sometoken" title="Someone Else">
          <img src="http://avatar_url" alt="Someone Else" height="20" width="20" title="Someone Else"/>

    </a>
EOHTML
      end
    end
    
    context "should display a profile image with a size of 80" do
      it "when there is no PA ID" do
        @me.avatar.stub(:url).and_return("http://avatar_url")
        helper.avatar_profile(@me, 80).should ==  "    <img src=\"http://avatar_url\" alt=\"My Self\" height=\"80\" width=\"80\" title=\"My Self\"/>\n"
      end

      it "and a link when there is a PA ID" do
        helper.stub(:current_person).and_return(@me)
        helper.should_receive(:pa_link).with('user/13').and_return("http://pa.com/user/13?pa_token=sometoken")
        @registered_user.avatar.stub(:url).and_return("http://avatar_url")
        helper.avatar_profile(@registered_user, 80).should ==  <<-EOHTML
    <a href="http://pa.com/user/13?pa_token=sometoken" title="Someone Else">
          <img src="http://avatar_url" alt="Someone Else" height="80" width="80" title="Someone Else"/>

    </a>
EOHTML
      end
    end
  end
end
