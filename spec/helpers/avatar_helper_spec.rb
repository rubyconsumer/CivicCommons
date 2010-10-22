require 'spec_helper'

describe AvatarHelper do
  before(:all) do
    @me = Factory.build(:normal_person, :first_name => "My", :last_name => "Self")
    @registered_user = Factory.build(:registered_user, :first_name => "Someone", :last_name => "Else", :people_aggregator_id => 13)
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
end
