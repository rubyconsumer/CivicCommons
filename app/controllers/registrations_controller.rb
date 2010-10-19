class RegistrationsController < Devise::RegistrationsController
  helper_method :form_presenter

  def form_presenter
    @presenter = RegistrationFormPresenter.new(resource)
  end


  # POST /resource/sign_up
  #
  # TODO - Can probably remove this override and let Devise handle this when
  # db1ce8eeb23141165af1c7ac38d63aff0c4a5957 gets tagged
  # http://github.com/plataformatec/devise/commit/db1ce8eeb23141165af1c7ac38d63aff0c4a5957
  #
  def create
    build_resource

    if resource.save
      set_flash_message :notice, :signed_up
      redirect_to after_inactive_sign_up_path_for(resource)
    else
      clean_up_passwords(resource)
      render_with_scope :new
    end
  end

  protected
  # Redirect after successful signup to principles page
  def after_inactive_sign_up_path_for(resource)
    principles_path
  end
end
