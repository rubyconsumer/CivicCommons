class Invite < ActiveRecord::Base
  belongs_to :person
  
  validates_format_of :invitation_token, :with => /([a-zA-Z]{2})([0-9]{4})/i, :msg => "invalid"
end
