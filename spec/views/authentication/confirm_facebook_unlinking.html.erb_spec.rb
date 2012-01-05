require 'spec_helper'

describe "/authentication/confirm_facebook_unlinking" do

  before(:each) do
    @person = stub_model(Person)
    @view.stub(:current_person).and_return(@person)
    render
  end

  def content_for(name)
    view.instance_variable_get(:@_content_for)[name]
  end

  it "should have 'Yes' link that points to the next step of Facebook unlinking" do
    content_for(:main_body).should have_selector('a.confirm-facebook-unlinking',:content => 'Yes', :href => before_facebook_unlinking_path)
  end

  it "should have 'No' link that points to settings page" do
    class SecureUrlHelperClass
      include SecureUrlHelper
      default_url_options[:host] = 'test.host'
    end
    secureUrlHelper = SecureUrlHelperClass.new
    content_for(:main_body).should have_selector('a.cancel',:content => 'No', :href => secureUrlHelper.secure_edit_user_url(@person))
  end

end