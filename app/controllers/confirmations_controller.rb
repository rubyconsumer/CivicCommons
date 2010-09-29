class ConfirmationsController < Devise::ConfirmationsController
  after_filter :create_shadow_account, :only => [:show]


  private

  def create_shadow_account
    Rails.logger.info("Creating shadow account for user with email #{resource.email}")
    response = PeopleAggregator::Person.create(firstName: resource.first_name,
                                    lastName:  resource.last_name,
                                    login:     resource.email,
                                    password:  resource.encrypted_password,
                                    email:     resource.email)
    save_pa_identifier(response)
  end

  def save_pa_identifier(response)
    Rails.logger.info("Success.  Person created.  Updating Person with People Agg ID...")
    if response.code == 200
      body = JSON.parse(response.body)
      person = Person.where(:email => resource.email).first
      if person
        person.people_aggregator_id = body["id"]
        person.save!
      end
    end
  end
end
