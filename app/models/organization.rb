class Organization < Person
  attr_accessor :authorized_to_setup_an_account
  validates_acceptance_of :authorized_to_setup_an_account, :on => :create, :message => 'must be checked.'
end