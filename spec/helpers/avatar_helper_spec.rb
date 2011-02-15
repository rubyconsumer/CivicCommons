require 'spec_helper'

describe AvatarHelper do
  before(:all) do
    @me = Factory.build(:normal_person, :first_name => "My", :last_name => "Self")
    @me.id = 1
    @registered_user = Factory.build(:registered_user, :first_name => "Someone", :last_name => "Else", :id => 13)
    @registered_user.id = 13
    @invalid_registered_user = Factory.build(:registered_user, :first_name => "Someone", :last_name => "Bad")
    @invalid_registered_user.id = 4
    @amazon_config = YAML.load_file( File.join(Rails.root, "config", "amazon_s3.yml"))[Rails.env]
  end

  context "link to profile" do
    it "should link to my private page" do
      helper.stub(:current_person).and_return(@me)
      helper.should_receive(:user_profile).with('me').and_return("/user/")

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

  context "text profile" do
    it "should display a users name with a link" do
      helper.stub(:current_person).and_return(@me)
      helper.should_receive(:pa_link).with("user/#{@registered_user.id}").and_return("http://pa.com/user/#{@registered_user.id}?pa_token=sometoken")

      @registered_user.avatar.url(:standard).gsub(/\?\d*/, '').should == "http://s3.amazonaws.com/#{@amazon_config['bucket']}/avatars/13/standard/test_image.jpg"
      @registered_user.avatar.stub(:url).and_return("http://avatar_url")

      helper.text_profile(@registered_user).should == <<-EOHTML
    <a href="http://pa.com/user/13?pa_token=sometoken" title="Someone Else">
      Someone Else
    </a>
EOHTML
    end

    it "should display a users name when they don't have a valid PA ID" do
      @invalid_registered_user.avatar.stub(:url).and_return("http://avatar_url")
      helper.text_profile(@invalid_registered_user).should == "Someone Bad"
    end
  end
  
  context "profile image" do
    it "should display a profile image with the default size" do
      @me.avatar.url(:standard).gsub(/\?\d*/, '').should == "http://s3.amazonaws.com/#{@amazon_config['bucket']}/avatars/1/standard/test_image.jpg"
      
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
      
      it "and no link when there is an invalid PA ID" do
        helper.stub(:current_person).and_return(@me)
        @invalid_registered_user.avatar.stub(:url).and_return("http://avatar_url")
        helper.avatar_profile(@invalid_registered_user, 80).should ==  <<-EOHTML
    <img src=\"http://avatar_url\" alt=\"Someone Bad\" height=\"80\" width=\"80\" title=\"Someone Bad\"/>
EOHTML
      end
    end
  end
end
