class ConfirmationsController < Devise::ConfirmationsController
  after_filter :create_shadow_account, :only => [:show]


  private

  def create_shadow_account
    Rails.logger.info("Creating shadow account for user with email #{resource.email}")
    PeopleAggregator::Person.create(firstName: resource.first_name,
                                    lastName:  resource.last_name,
                                    login:     resource.email,
                                    password:  resource.encrypted_password,
                                    email:     resource.email)
  end


end
