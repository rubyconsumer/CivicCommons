class RegistrationsController < Devise::RegistrationsController

  before_filter :require_ssl

  helper_method :form_presenter

  def after_inactive_sign_up_path_for(resource)
    url_for :new_person_confirmation
  end
  def form_presenter
    @presenter = RegistrationFormPresenter.new(resource)
  end
end
