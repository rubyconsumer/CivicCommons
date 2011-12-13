class RegistrationFormPresenter < PresenterForm

  def any_errors?
    errors.any?{|key,val|val.present?}
  end

  def blank_form?
    self.attributes == @object.class.new.attributes
  end

  def show_normal_fields?
    any_errors?
  end

  def show_facebook_fields?
    not self.authentications.blank?
  end

end
