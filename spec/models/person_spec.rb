require 'spec_helper'
require 'acceptance/support/facebookable'

describe Person do
  subject { Factory.build(:normal_person) }

  it { should be_valid }
  it { should have_attached_file :avatar }
  it { should validate_attachment_content_type(:avatar).allowing([
              "image/gif", "image/jpeg", "image/png", "image/bmp"])
              .rejecting(['text/plain']) }
end

describe Person do
  include Facebookable
  context "Associations" do
    it "should has_many Authentications" do
      Person.reflect_on_association(:authentications).macro == :has_many
    end
    it "should have many survey_responses" do
      Person.reflect_on_association(:survey_responses).macro == :has_many
    end
    it "should have and belongs to many organizations" do
      Person.reflect_on_association(:organizations).macro.should == :has_and_belongs_to_many
    end
    it "should be have uniqueness constraint on habtm organiazation" do
      Person.reflect_on_association(:organizations).options[:uniq].should be_true
    end
  end

  describe "validate required data" do

    before(:each) do
      @person = Factory.build(:normal_person)
    end

    it "should require first name and last name" do
      @person.first_name = ''
      @person.last_name = ''
      @person.should_not be_valid
    end

    it "should require email address" do
      @person.email = ''
      @person.should_not be_valid
    end

    context "zip code" do
      def given_a_person_with_no_zip_code
        @person = Factory.build(:normal_person,:zip_code =>'')
      end

      def given_a_registered_person_without_a_zip_code
        @person = Factory :registered_user
        @person.zip_code = nil
      end

      def given_a_registered_person_with_a_short_zip_code
        @person = Factory :registered_user
        @person.zip_code = "all"
      end

      it "should be validated when a new person is registering" do
        given_a_person_with_no_zip_code
        @person.valid?
        @person.errors.should have_key(:zip_code)
      end

      it "should be validated when the person already exists" do
        given_a_registered_person_without_a_zip_code
        @person.valid?
        @person.errors.should have_key(:zip_code)
      end

      it "should be validated when the person already exists and has a short (invalid) zip code" do
        given_a_registered_person_with_a_short_zip_code
        @person.valid?
        @person.errors.should have_key(:zip_code)
      end

      it "should be validated when facebook unlinking" do
        given_a_person_with_no_zip_code
        @person.stub(:facebook_unlinking?).and_return(true)
        @person.valid?
        @person.errors.should have_key(:zip_code)
      end

      it "should be validated when creating from auth" do
        given_a_person_with_no_zip_code
        @person.stub(:create_from_auth?).and_return(true)
        @person.valid?
        @person.errors.should have_key(:zip_code)
      end
    end

    it "strips the @ symbol from the front of the Twitter username" do
      @person.twitter_username = '@SomeTwitterUser'
      @person.twitter_username.should == '@SomeTwitterUser'
      @person.should be_valid
      @person.twitter_username.should == 'SomeTwitterUser'
    end
  end


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
      person.save
      person
    end

    it "should not find when only first name exists" do
      given_a_person_with_name "Wendy"
      Person.find_all_by_name("Wendy").should be_blank
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
      person = Factory.build(:normal_person)
      person.first_name = "ektor"
      person.last_name = "van capsula"
      person.name.should == "ektor van capsula"
    end

    it "should display names without leading spaces when the first name is missing" do
      person = Factory.build(:normal_person)
      person.first_name = ""
      person.last_name = "van capsula"
      person.name.should == "van capsula"
    end

    it "should display names without trailing spaces when the last name is missing" do
      person = Factory.build(:normal_person)
      person.first_name = "ektor"
      person.last_name = ""
      person.name.should == "ektor"
    end
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
    context "when not from facebook" do
      it "should send a confirmation email" do
        given_a_new_user_registered
        mailing = ActionMailer::Base.deliveries.first
        mailing[:from].to_s.should == Civiccommons::Config.devise['email']
        mailing.to.should == [@person.email]
        mailing.subject.should == "Confirmation instructions"
      end

    end
    context "from facebook" do
      it "does not send a confirmation email" do
          @person = Factory.build(:registered_user_with_facebook_authentication)
          ActionMailer::Base.deliveries.any? do | mail |
            mail.subject.include? "Confirmation"
          end.should == false
      end
    end
    it "should not send a welcome email" do
      given_a_new_user_registered
      mailing = ActionMailer::Base.deliveries.last
      mailing.subject.should_not == "Welcome to The Civic Commons"
    end

    it "should send a notification email to register@civiccommons.com" do
      given_a_new_user_registered
      mailing = ActionMailer::Base.deliveries.last
      mailing[:from].to_s.should == Civiccommons::Config.devise['email']
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
      mailing[:from].to_s.should == Civiccommons::Config.devise['email']
      mailing.to.should == [person.email]
      mailing.subject.should == "Welcome to The Civic Commons"
      ActionMailer::Base.deliveries.length.should == 3
      person.save
      ActionMailer::Base.deliveries.length.should == 3
    end
  end

  context "Facebook authentication" do
    describe "when having a facebook authentication associated" do
      def given_a_person_with_facebook_auth
        @person = Factory.build(:normal_person)
        @authentication = Factory.build(:authentication, :provider => 'facebook')
        @person.link_with_facebook(@authentication)
      end
      it "should show that it does have the correct authentication" do
        given_a_person_with_facebook_auth
        @person.facebook_authentication.should == @authentication
        @person.facebook_authentication.should be_persisted
      end
      it "should return true if an account is facebook authenticated" do
        given_a_person_with_facebook_auth
        @person.facebook_authenticated?.should be_true
      end
      it "should wiped out the current person's password, so they can't login using local account anymore" do
        @person = Factory.create(:normal_person, :password => 'password')
        @person.valid_password?('password').should be_true
        @authentication = Factory.build(:authentication, :provider => 'facebook')
        @person.link_with_facebook(@authentication)
        @person.valid_password?('password').should be_false
      end
    end
    describe "link_with_facebook" do
      it "should return true if correctly saved" do
        @person = Factory.build(:normal_person)
        @authentication = Factory.build(:authentication, :provider => 'facebook')
        @person.link_with_facebook(@authentication).should be_true
      end
      it "should return false if incorrectly saved" do
        @person = Factory.build(:normal_person)
        @authentication = Authentication.new
        @person.link_with_facebook(@authentication).should be_false
      end
    end
    describe "when an account is not facebook authenticated" do
      it "should return false if we check for it" do
        @person = Factory.build(:normal_person)
        @person.facebook_authenticated?.should be_false
      end
    end
    describe "conflicting_email?" do
      def given_a_normal_person
        @person = Factory.build(:normal_person, :email => 'johnd@test.com')
      end
      it "should return false if other email is blank?" do
        given_a_normal_person
        @person.conflicting_email?(nil).should be_false
        @person.conflicting_email?('').should be_false
      end
      it "should return false if other_email is the same as existing email" do
        given_a_normal_person
        @person.conflicting_email?('JohnD@Test.com').should be_false
      end
      it "should return true if other_email is same NOT the same as existing email " do
        given_a_normal_person
        @person.conflicting_email?('johnd.different.email@test.com').should be_true
      end
    end
    describe "facebook_profile_pic_url" do
      def given_a_normal_person_with_facebook_auth
        @person = Factory.build(:normal_person, :email => 'johnd@test.com')
        @authentication = Factory.build(:facebook_authentication, :uid => 12345)
        @person.link_with_facebook(@authentication)
      end

      it "should return the correct picture url of Facebook" do
        given_a_normal_person_with_facebook_auth
        @person.facebook_profile_pic_url.should == 'https://graph.facebook.com/12345/picture?type=square'
      end
      it "should return the correct type on the picture url of Facebook" do
        given_a_normal_person_with_facebook_auth
        @person.facebook_profile_pic_url(:large).should == 'https://graph.facebook.com/12345/picture?type=large'
      end
      it "should return nil if user has not been authenticated with fb" do
         @person = Factory.build(:normal_person, :email => 'johnd@test.com')
         @person.facebook_profile_pic_url.should be_nil
      end
    end
    describe "create account with facebook hash" do
      let(:person) { Person.build_from_auth_hash(auth_hash)}
      it "should have first name" do
        person.first_name.should == 'John'
      end
      it "should have last name" do
        person.last_name.should == 'Doe'
      end
      it "should have email" do
        person.email.should == auth_hash["info"]["email"]
      end
    end
    describe "Change Password" do
      def reset_email_deliveries_count
        ActionMailer::Base.deliveries = []
      end
      def given_a_person_with_facebook_auth
        @person = Factory.build(:registered_user_with_facebook_authentication, :email => 'johnd@example.com')

      end
      def given_a_regular_person
        @person = Factory.create(:registered_user, :email => 'johnd@example.com')
      end
      it "should not send email when account is facebook authenticated" do
        given_a_person_with_facebook_auth
        reset_email_deliveries_count
        Person.send_reset_password_instructions({:email => 'johnd@example.com'})
        ActionMailer::Base.deliveries.length.should == 0
      end
      it "should send email when it's not facebook authenticated" do
        given_a_regular_person
        reset_email_deliveries_count
        Person.send_reset_password_instructions({:email => 'johnd@example.com'})
        ActionMailer::Base.deliveries.length.should == 1
      end
    end
  end

  context "Facebook unlinking" do
    def given_a_person_with_facebook_auth
      @person = Factory.build(:normal_person, :email => 'johnd@example.com')
      @authentication = Factory.build(:authentication, :provider => 'facebook')
      @person.link_with_facebook(@authentication)

      # makes sure that password is nil first
      @person.encrypted_password.should be_blank
    end

    def when_unlinking_from_facebook_successfully(email = 'johnd-new-email@example.com')
      @person.unlink_from_facebook(:email => email, :password => 'test123', :password_confirmation => 'test123')
      @person.reload
    end

    def when_unlinking_from_facebook_unsuccessfully(person_hash = {})
      @person.unlink_from_facebook(person_hash)
    end

    it "should update the person's email and password and password confirmation" do
      given_a_person_with_facebook_auth
      when_unlinking_from_facebook_successfully
      @person.email.should == "johnd-new-email@example.com"
    end

    it "should destroy the authentication record" do
      given_a_person_with_facebook_auth
      when_unlinking_from_facebook_successfully
      @person.facebook_authentication.should be_blank
    end

    it "should return the person object" do
      given_a_person_with_facebook_auth
      when_unlinking_from_facebook_successfully
      @person.should be_an_instance_of(Person)
    end
    context "sending notification email" do
      it "should be sent if email is updated" do
        given_a_person_with_facebook_auth
        Notifier.deliveries = []
        when_unlinking_from_facebook_successfully
        Notifier.deliveries.length.should == 1
      end

      it "should be sent to the old email address, and the new email address" do
        given_a_person_with_facebook_auth
        Notifier.deliveries = []
        when_unlinking_from_facebook_successfully
        Notifier.deliveries.first.to.should == ["johnd@example.com", "johnd-new-email@example.com"]
      end

      it "should be not be sent if email is the same" do
        given_a_person_with_facebook_auth
        Notifier.deliveries = []
        when_unlinking_from_facebook_successfully('johnd@example.com')
        @person.should_not be_facebook_authenticated
        Notifier.deliveries.length.should == 0
      end
    end

    context "failure" do
      context "on email" do
        it "should err out when email is not present" do
          given_a_person_with_facebook_auth
          when_unlinking_from_facebook_unsuccessfully
          @person.errors[:email].should == ["can't be blank", "please use a longer email address"]
        end
        it "should have the original email after failure" do
          given_a_person_with_facebook_auth
          @person.unlink_from_facebook({})
          @person.errors[:email].should == ["can't be blank", "please use a longer email address"]
          @person.reload.email.should == "johnd@example.com"
        end
      end
      it "should err out when password is not present" do
        given_a_person_with_facebook_auth
        when_unlinking_from_facebook_unsuccessfully
        @person.errors[:password].should == ["can't be blank"]
      end
      it "should err out when passwords do not match" do
        given_a_person_with_facebook_auth
        when_unlinking_from_facebook_unsuccessfully({:password => 'test123',:password_confirmation => 'differentpasswordhere'})
        @person.errors[:password].should == ["Passwords do not match"]
      end
    end
  end

  context "password_required?" do
    def given_a_person_with_facebook_auth
      @person = Factory.build(:normal_person)
      @authentication = Factory.build(:authentication, :provider => 'facebook')
      @person.link_with_facebook(@authentication)
    end

    it "should return return false if facebook_authenticated? is true" do
      given_a_person_with_facebook_auth
      @person.send(:password_required?).should be_false
    end

    it "should return true if facebook_unlinking? is true" do
      given_a_person_with_facebook_auth
      @person.facebook_unlinking = true
      @person.send(:password_required?).should be_true
    end

    it "should return true if not persisted and not create from auth" do
      @person = Factory.build(:normal_person)
      @person.send(:password_required?).should be_true
    end

    it "should return true if user is changing password by having password and password confirmation field present" do
      Factory.create(:registered_user)
      @person = Person.last
      @person.send(:password_required?).should be_false
      @person.password = 'test123'
      @person.password_confirmation = 'test123'
      @person.send(:password_required?).should be_true
    end
  end

  context "when finding by the most active" do

    before(:each) do
      @person1 = Factory.create(:sequence_user, name: "Lazy Sue")
      @person2 = Factory.create(:sequence_user, name: "Hyper Fred")
    end

    let(:convo) do
      Factory.create(:conversation)
    end

    it "will return the most active to least active users" do
      Factory.create(:contribution_activity, item_id: convo.id, person: @person2);
      results = Person.find_confirmed_order_by_most_active

      # Check order of objects in the results
      results[0].first_name.should == "Hyper"
      results[1].first_name.should == "Lazy"
    end

  end

  context "when deleting an account" do
    after(:each) do
      Person.delete_all
    end

    before(:each) do
      @person = Factory.create(:normal_person)
    end

    it "will delete all subscriptions" do
      Factory.create(:conversation, owner: @person.id)
      Factory.create(:issue_subscription, person: @person)

      @person.subscriptions.length.should == 2
      @person.destroy
      Subscription.find(:all).length.should == 0
    end

    it "will delete any authentications" do
      Factory.create(:facebook_authentication, person: @person)

      Authentication.find(:all).length.should == 1
      @person.destroy
      Authentication.find(:all).length.should == 0
    end

  end

  it 'allows you to unsubscribe from daily digest' do
    @person = Factory.create(:normal_person)
    @person.unsubscribe_from_daily_digest
    @person.should_not be_subscribed_to_daily_digest
  end

  context "paperclip" do

    it "will have necessary db columns for paperclip" do
      should have_db_column(:avatar_file_name).of_type(:string)
      should have_db_column(:avatar_content_type).of_type(:string)
      should have_db_column(:avatar_file_size).of_type(:integer)
    end

    it "will only allow image attachments" do
      # allowed image mimetypes are based on what we have seen in production
      should validate_attachment_content_type(:avatar).
        allowing('image/bmp', 'image/gif', 'image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png').
        rejecting('text/plain', 'text/xml')
    end

    it "will have an existing default image" do
      paperclip_default_file_exists?('original').should be_true
      Person.attachment_definitions[:avatar][:styles].each do |style, size|
        paperclip_default_file_exists?(style.to_s).should be_true
      end
    end

    def paperclip_default_file_exists?(style)
      default_url = Person.attachment_definitions[:avatar][:default_url].gsub(/\:style/, style)
      default_file = File.join(Rails.root, 'public', default_url)
      File.exist?(default_file)
    end

  end

  context "defaults" do
    it "should have allow_facebook_connect? to be true by default" do
      Person.new.allow_facebook_connect?.should be_true
    end
  end

  context "subscribed" do
    it "conversations returns a users conversation subscriptions sorted decending" do
      subject.subscriptions_conversations.should_receive(:order).with('created_at desc')
      subject.subscribed_conversations
    end
    it "issues returns a users issue subscriptions sorted decending" do
      subject.subscriptions_issues.should_receive(:order).with('created_at desc')
      subject.subscribed_issues
    end
    it "organizations returns a users organization subscriptions sorted decending" do
      subject.subscriptions_organizations.should_receive(:order).with('created_at desc')
      subject.subscribed_organizations
    end
  end

  context "display_name" do
    it 'should display the last name first and the first name last' do
      user = Factory.build(:normal_person, :first_name => "Tom", :last_name => "Kat")

      user.display_name.should == "Kat, Tom"
    end

    it "should display the full name if the first name is missing" do
      user = Factory.build(:normal_person, :first_name => nil, :last_name => "Kat")

      user.display_name.should == "Kat"
    end

    it "should display the full name if the last name is missing" do
      user = Factory.build(:normal_person, :first_name => "Tom", :last_name => nil)

      user.display_name.should == "Tom"
    end
  end

end
