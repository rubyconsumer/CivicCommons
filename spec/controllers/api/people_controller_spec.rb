require 'spec_helper'

describe Api::PeopleController do

  it "should return 200 on successful update" do
    person = Factory.create(:normal_person, :people_aggregator_id => 42)

    put :update, :people_aggregator_id => 42 
    response.should be_success
  end

  it "should update password" do
    person = Factory.create(:normal_person, :people_aggregator_id => 42)

    put :update, :people_aggregator_id => 42, :person => {
      :password_salt => "$2a$10$95c0ac175c8566911bb039$",
      :encrypted_password =>
      "$2a$10$95c0ac175c8566911bb03uvHgL7PXXveLmPKg4gZ7K/md5a5aXD4m"}

    response.should be_success

    person.reload
    person.password_salt.should == "$2a$10$95c0ac175c8566911bb039"
    person.encrypted_password.should == "$2a$10$95c0ac175c8566911bb03uvHgL7PXXveLmPKg4gZ7K/md5a5aXD4m"
  end

  it "should return 404 when not found" do
    person = Factory.create(:normal_person, :people_aggregator_id => 42)

    put :update, :people_aggregator_id => 43
    response.status.should == 404
  end

    it "should return unprocessable entity on bad update" do
    person = Factory.create(:normal_person, :people_aggregator_id => 42)

    # try changing the email address to something invalid
    put(:update, :people_aggregator_id => 42, :person => {:email => "foo"})
    response.status.should == 422
  end
end
