require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Unscribing from daily digest", %q{
  Due to CAN-SPAM law, user must be opted out within
  30 days.
  } do

  scenario "Member missing required information" do
    given_a_member_missing_required_information
    when_they_unsubscribe_from_the_daily_digest
    then_they_should_not_be_subscribed_to_the_daily_digest
  end

  scenario "Member with all information" do
    given_a_member
    when_they_unsubscribe_from_the_daily_digest
    then_they_should_not_be_subscribed_to_the_daily_digest
  end

  def given_a_member
    @member = FactoryGirl.build(:normal_person)
  end

  def given_a_member_missing_required_information

    @member = Person.new({:email => 'member_missing_info@website.com', :first_name=>'zee',
                          :last_name => 'Your', :name=>'Zee', :daily_digest => true })
  end

  def when_they_unsubscribe_from_the_daily_digest
    @member.unsubscribe_from_daily_digest
  end

  def then_they_should_not_be_subscribed_to_the_daily_digest
    @member = Person.find_by_email(@member.email)
    @member.should be_a(Person)
    @member.should_not be_subscribed_to_daily_digest

  end
end
