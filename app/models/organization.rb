class Organization < Person
  attr_accessor :authorized_to_setup_an_account
  has_one :organization_detail
  validates_presence_of :name
  validates_acceptance_of :authorized_to_setup_an_account, :on => :create, :message => 'must be checked.'
  
  alias_attribute :name, :last_name
  
  def allow_facebook_connect?
    false
  end

end
