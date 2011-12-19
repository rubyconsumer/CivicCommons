class Organization < Person
  attr_accessor :authorized_to_setup_an_account
  has_one :organization_detail
  validates_acceptance_of :authorized_to_setup_an_account, :on => :create, :message => 'must be checked.'

  def name= name
    self.last_name = name
  end
  def name
    self.last_name
  end
end
