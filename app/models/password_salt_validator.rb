require 'bcrypt'

class PasswordSaltValidator < ActiveModel::Validator
  
  # Ensure the salt is a valid bcrypt salt since the salt can be assigned
  # via People Aggregator API updates.
  # NOTE this is a very leaky abstraction in that it assumes BCrypt is the
  # password encryption algorithm
  #
  def validate(record)
    if record.password_salt && !BCrypt::Engine.valid_salt?(record.password_salt)
      record.errors[:password_salt] << "Invalid salt format"
    end
  end
end
