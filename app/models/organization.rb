class Organization < Person
  include Subscribable
  attr_accessor :authorized_to_setup_an_account

  has_one :organization_detail

  validates_presence_of :name
  validates_acceptance_of :authorized_to_setup_an_account, :on => :create, :message => 'must be checked.'

  alias_attribute :name, :last_name

  define_method(:title) do
    name
  end

  def allow_facebook_connect?
    false
  end
end
