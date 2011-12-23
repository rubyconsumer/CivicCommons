class Organization < Person
  attr_accessor :authorized_to_setup_an_account
  has_one :organization_detail
  validates_presence_of :name
  has_and_belongs_to_many :members, :class_name => 'Person', :association_foreign_key => 'person_id', :join_table => 'organization_members', :uniq => true
  validates_acceptance_of :authorized_to_setup_an_account, :on => :create, :message => 'must be checked.'
  
  alias_attribute :name, :last_name
  
  def allow_facebook_connect?
    false
  end
  
  def has_member?(user)
    self.members.exists?(user)
  end
  
  def join_as_member(person)
    self.members << person
  end
  
  def remove_member(person)
    self.members.delete(person)
  end
end
