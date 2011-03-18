class MustBeLoggedInValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    record.errors[:base] << "You must be logged in" if value.blank?
  end

end
