require 'spec_helper'
require 'devise/test_helpers'

describe RegistrationsController do
  
  def mock_person(stubs={})
    @mock_person ||= mock_model(Person, stubs).as_null_object
  end

  before(:each) do
    request.env["devise.mapping"] = Devise.mappings[:person]
  end
  context "GET new_organization" do
    it "should have instance" do
      get :new_organization
      assigns(:person).should be_an_instance_of(Organization)
    end
    it "should render view new_organization" do
      get :new_organization
      response.should render_template :new_organization
    end
  end
  context "POST create_organization" do
    before(:each) do
      @person = Factory.create(:registered_user)
      warden.stub(:authenticate!).and_return(@person)
    end
    
    it "should render new_organization template when not able to save" do
      @person.stub!(:save).and_return(false)
      post :create_organization
      response.should render_template :new_organization
    end
  end

end
