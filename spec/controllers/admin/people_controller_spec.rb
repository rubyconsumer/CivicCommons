require 'spec_helper'

describe Admin::PeopleController, "locking/unlocking" do
  before(:each) do
    @admin = Factory.create(:admin_person)
    controller.stub!(:current_person).and_return(@admin)
    @person = Factory.create(:normal_person)
  end
  
  it "should allow locking of a person" do
    put 'lock_access', {:id => @person.id}

    response.should be_redirect

    @person.reload
    @person.locked_at.should_not be_nil
  end

  it "should allow unlocking of a person" do
    @person.lock_access!
    
    put 'unlock_access', {:id => @person.id}

    response.should be_redirect

    @person.reload
    @person.locked_at.should be_nil
  end
  
end
