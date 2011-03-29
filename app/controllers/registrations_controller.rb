class RegistrationsController < Devise::RegistrationsController

  before_filter :require_ssl

  helper_method :form_presenter

  def form_presenter
    @presenter = RegistrationFormPresenter.new(resource)
  end
end
