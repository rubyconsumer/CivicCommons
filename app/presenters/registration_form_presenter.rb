class RegistrationFormPresenter < PresenterForm
  
  def any_errors?
    errors.any?{|key,val|val.present?}
  end
  
  def show_normal_fields?
    any_errors?
  end

  def show_facebook_fields?
    !any_errors?
  end
  
end
