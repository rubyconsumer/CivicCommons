class RegistrationsController < Devise::RegistrationsController
  helper_method :form_presenter

  def form_presenter
    resource.invite = Invite.new
    @presenter = RegistrationFormPresenter.new(resource)
  end
end
