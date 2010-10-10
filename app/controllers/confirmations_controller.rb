class ConfirmationsController < Devise::ConfirmationsController
  after_filter :create_shadow_account, :only => [:show]


  private

  def create_shadow_account
    Rails.logger.info("Creating shadow account for user with email #{resource.email}")
    pa_person = PeopleAggregator::Person.create(firstName: resource.first_name,
                                    lastName:  resource.last_name,
                                    login:     resource.email,
                                    password:  resource.encrypted_password,
                                    email:     resource.email,
                                    profilePictureURL: resource.avatar.url(:standard))
    save_pa_identifier(pa_person)
  end

  def save_pa_identifier(pa_person)
    Rails.logger.info("Success.  Person created.  Updating Person with People Agg ID...")
    person = Person.where(:email => resource.email).first
    if person
      person.people_aggregator_id = pa_person.id
      person.save!
    end
  end
end
