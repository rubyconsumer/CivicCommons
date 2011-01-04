class Invite < ActiveRecord::Base
  belongs_to :person

  validates_format_of :invitation_token, :with => /^([a-zA-Z]{3})([0-9]{4})$/i, :msg => "invalid"
  
  scope :group_by_invitation_token, {:group => 'invitation_token'} 
  
  def self.summary_report
    self.group_by_invitation_token.count
  end
end
