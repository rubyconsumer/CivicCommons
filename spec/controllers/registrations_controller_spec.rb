require 'spec_helper'
include ControllerMacros

describe RegistrationsController do
  before(:each) do
    setup_person
  end

  context 'GET principles' do
    it 'will render the "registrations/principles" template' do
      get :principles
      response.should be_success
      response.should render_template('registrations/principles')
    end
  end

  context 'POST create' do
    context "with facebook authentication attributes" do
      before do
        attributes = Factory.attributes_for(:normal_person, email: 'facebook@theciviccommons.com')
        attributes['authentications_attributes'] = [Factory.attributes_for(:facebook_authentication, person: nil)]
        post :create, person: attributes
      end
      it 'will store Facebook authentication' do
        Person.find_by_email('facebook@theciviccommons.com').should be_facebook_authenticated
      end
      it "will confirm the person" do
        Person.find_by_email('facebook@theciviccommons.com').should be_confirmed
      end
    end

    context "without facebook authentication" do
      before do
        attributes = Factory.attributes_for(:normal_person, email: 'normal@theciviccommons.com')
        post :create, person: attributes
      end
      it 'will not store facebook authentication' do
        Person.find_by_email('normal@theciviccommons.com').should_not be_facebook_authenticated
      end
      it 'will not be confirmd' do
        Person.find_by_email('normal@theciviccommons.com').should_not be_confirmed
      end
    end

    it 'will render #new if there was a validation error' do
      attributes = Factory.attributes_for(:invalid_person)
      post :create, person: attributes
      response.should be_success
      response.should render_template('registrations/new')
    end
  end
end