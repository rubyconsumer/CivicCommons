require 'spec_helper'

describe OrganizationsHelper do

  context "organization_membership_button" do
    def mock_person(stubs={})
      @mock_person ||= mock_model(Person, stubs).as_null_object
    end
    
    def mock_organization(stubs={})
      @mock_organization ||= mock_model(Organization, stubs).as_null_object
    end
    
    it "should return the correct button if user is a member" do
      organization = mock_organization
      organization.stub!(:has_member?).and_return(true)
      helper.organization_membership_button(organization, mock_person).should == "<p class=\"membership\"><a href=\"/user/1001/remove_membership\" class=\"button remove\" data-method=\"delete\" data-remote=\"true\" data-type=\"html\" rel=\"nofollow\">Leave this organization</a></p>"
    end
    it "should return the correct button if user is not a member" do
      organization = mock_organization
      organization.stub!(:has_member?).and_return(false)
      helper.organization_membership_button(organization, mock_person).should == "<p class=\"membership\"><a href=\"/user/1003/join_as_member\" class=\"button join\" data-type=\"html\">I'm a member of this Organization</a></p>"
    end
  end
end
