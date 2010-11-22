require 'spec_helper'

describe Person do

  describe "when parsing the name" do
    it "should parse simple name" do
      first, last = Person.parse_name("John Doe")
      first.should == "John"
      last.should == "Doe"
    end
    
    it "should have blank last name when missing" do
      first, last = Person.parse_name("John")
      first.should == "John"
      last.should == ""
    end
    
    it "should handle complex last name" do
      first, last = Person.parse_name("John van Buren")
      first.should == "John"
      last.should == "van Buren"
    end

    it "should handle multi names" do
      first, last = Person.parse_name("Gladys s.w. Lum")
      first.should == "Gladys"
      last.should == "s.w. Lum"
    end

    it "should strip extra whitespace between name parts" do
      first, last = Person.parse_name("  The Grand       Duchess of Windsor  ")
      [first, last].join(" ").should == "The Grand Duchess of Windsor"
    end
  end

  describe "when finding all by name" do

    def given_a_person_with_name(name)
      person = Factory.create(:normal_person)
      person.name = name
      person.password = "password"
      person.email = "wendy@example.com"
      person.save!
      person
    end

    it "should find when only first name exists" do
      person = given_a_person_with_name "Wendy"
      Person.find_all_by_name("Wendy").should == [person]
    end
    
    it "should find when first and last name" do
      person = given_a_person_with_name "Wendy Smith"
      Person.find_all_by_name("Wendy Smith").should == [person]
    end

    it "should find when first and last has prefix" do
      person = given_a_person_with_name "Wendy van Buren"
      Person.find_all_by_name("Wendy van Buren").should == [person]
    end
  end
  
  describe "when setting the name" do
    it "should split the entry into first name and last name" do
      person = Factory.create(:normal_person)
      person.name = "John Doe"
      person.first_name.should == "John"
      person.last_name.should == "Doe"
    end
  end
  
  context "when setting the email address" do
    it "should not allow emails that are too short" do
      person = Factory.build(:normal_person, :email => "a@b.c")
      person.valid?.should be_false
      person.should have_validation_error(:email, /please use a longer email address/)
    end
    
    it "should not allow emails that are too long" do
      person = Factory.build(:normal_person, :email => "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890@1234567890b.c")
      person.valid?.should be_false
      person.should have_validation_error(:email, /please use a shorter email address/)
    end
  end
  
  describe "when displaying a name" do
    it "should respect case of name entered by person" do 
      person = Factory.create(:normal_person)
      person.first_name = "ektor"
      person.last_name = "van capsula"
      person.name.should == "ektor van capsula"
    end
    
    it "should display names without leading spaces when the first name is missing" do
      person = Factory.create(:normal_person)
      person.first_name = ""
      person.last_name = "van capsula"
      person.name.should == "van capsula"
    end
    
    it "should display names without trailing spaces when the last name is missing" do
      person = Factory.create(:normal_person)
      person.first_name = "ektor"
      person.last_name = ""
      person.name.should == "ektor"
    end
  end


  it "creates a shadow account after saving" do
    person = Factory.build(:person_with_shadow_account)
    PeopleAggregator::Person.stub!(:create).and_return(OpenStruct.new(id: 42))
    person.save
    person.people_aggregator_id.should == 42
  end


  it "doesn't create a shadow account when there are errors" do
    person = Factory.build(:person_with_shadow_account)

    PeopleAggregator::Person.stub(:create) do
      raise PeopleAggregator::Error.new("There was an error saving this person.")
    end

    lambda { person.save }.should raise_error(ActiveRecord::RecordNotSaved)
    person.errors[:person].should include("There was an error saving this person.")

  end

  describe "upon creation" do
    before(:each) do
      ActionMailer::Base.deliveries = []
    end
    def given_a_new_user_registered
      @person = Factory.create(:normal_person)
      @person.first_name = 'John'
      @person.last_name = 'Doe'
      @person.save
    end
    it "should send a confirmation email" do
      given_a_new_user_registered
      mailing = ActionMailer::Base.deliveries.first
      mailing.from.should == [Civiccommons::Config.devise_email]
      mailing.to.should == [@person.email]
      mailing.subject.should == "Confirmation instructions"
    end
    
    it "should not send a welcome email" do
      given_a_new_user_registered
      mailing = ActionMailer::Base.deliveries.last
      mailing.subject.should_not == "Welcome to The Civic Commons"
    end
    
    it "should send a notification email to register@civiccommons.com" do
      given_a_new_user_registered
      mailing = ActionMailer::Base.deliveries.last
      mailing.from.should == [Civiccommons::Config.devise_email]
      mailing.to.should == ["register@theciviccommons.com"]
      mailing.subject.should == "New User Registered"
      mailing.body.include?(@person.email).should be_true
    end
  end
  describe "after confirmation of email" do
    it "should send a welcome email" do
      ActionMailer::Base.deliveries = []
      person = Factory.create(:normal_person)
      
      mailing = ActionMailer::Base.deliveries.last
      mailing.subject.should_not == "Welcome to The Civic Commons"
      
      person.confirmed_at = Time.now
      person.save
      
      person.confirmed_at.should_not be_blank
      
      mailing = ActionMailer::Base.deliveries.last
      mailing.from.should == [Civiccommons::Config.devise_email]
      mailing.to.should == [person.email]
      mailing.subject.should == "Welcome to The Civic Commons"
      ActionMailer::Base.deliveries.length.should == 3
      person.save
      ActionMailer::Base.deliveries.length.should == 3
    end
  end

  describe "upon api update" do
    it "can update name" do
      person = Factory.create(:normal_person)
      person.api_update(:name => "John Foo")
      person.name.should == "John Foo"
    end

    it "skips encrypted password when missing" do
      person = Factory.create(:normal_person)
      encrypted_before = person.encrypted_password

      person.api_update({})

      person.encrypted_password.should == encrypted_before
    end

    it "skips encrypted password and salt when password salt is missing" do
      person = Factory.create(:normal_person)
      encrypted_before = person.encrypted_password
      salt_before = person.password_salt

      person.api_update(:encrypted_password =>
                        "$2a$10$95c0ac175c8566911bb03uvHgL7PXXveLmPKg4gZ7K/md5a5aXD4m")

      person.encrypted_password.should == encrypted_before
      person.password_salt.should == salt_before
    end
    
    it "skips encrypted password and salt when encrypted password is missing" do
      person = Factory.create(:normal_person)
      encrypted_before = person.encrypted_password
      salt_before = person.password_salt

      person.api_update(:password_salt => "$2a$10$95c0ac175c8566911bb039$")

      person.encrypted_password.should == encrypted_before
      person.password_salt.should == salt_before
    end
    
    it "strips trailing $ from password_salt and updates encrypted password and salt" do
      person = Factory.create(:normal_person)

      pepper = Civiccommons::Config.devise_pepper
      password_salt = "$2a$10$95c0ac175c8566911bb039"

      encrypted_password = Devise::Encryptors::Bcrypt.
        digest("testpass", 10, password_salt, pepper)
      
      person.api_update(:password_salt => "#{password_salt}$",
                        :encrypted_password => encrypted_password)

      person.save.should be_true
      
      person.password_salt.should == password_salt
      person.encrypted_password.should == encrypted_password

      person.valid_password?("testpass").should be_true
    end

    it "should have error on invalid password salt" do
      person = Factory.create(:normal_person)
      
      person.api_update(:password_salt => "$2a$10$95c0ac175c8$",
                        :encrypted_password =>
                        "$2a$10$95c0ac175c8566911bb03uvHgL7PXXveLmPKg4gZ7K/md5a5aXD4m")

      person.save.should be_false
      person.errors[:password_salt].should_not be_nil
    end
    
  end

  describe "upon password reset" do
    it "should call people aggregator with update when valid passwords" do
      PeopleAggregator::Account.should_receive(:update).once
      
      person = Factory.create(:normal_person)
      person.send(:generate_reset_password_token!)

      person.reset_password!("foobar", "foobar")
    end

    it "should not call people aggregator with update when passwords to not match" do
      PeopleAggregator::Account.should_not_receive(:update)
      
      person = Factory.create(:normal_person)
      person.send(:generate_reset_password_token!)

      person.reset_password!("foobar", "foo")
    end

    it "should not call people aggregator with update when invalid password" do
      PeopleAggregator::Account.should_not_receive(:update)
      
      person = Factory.create(:normal_person)
      person.send(:generate_reset_password_token!)

      person.reset_password!("", "")
    end
  end
end
