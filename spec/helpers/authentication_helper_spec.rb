require 'spec_helper'

describe AuthenticationHelper do

  context "unlink_from_facebook_link" do
    it "should return the link" do
      unlink_from_facebook_link.should have_selector 'a.connectacct-link.facebook-auth.disconnect-fb', :href => confirm_facebook_unlinking_path
    end
  end
  context "link_with_facebook_link" do
    # error when invoking this path, so faking it here.
    def person_omniauth_authorize_path(options ={})
      '/path/here' 
    end

    it "should return the correct link" do
      link_with_facebook_link.should have_selector 'a.connectacct-link.facebook-auth', :href => "/path/here"
    end
  end
end
