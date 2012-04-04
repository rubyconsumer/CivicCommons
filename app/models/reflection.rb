class Reflection < ActiveRecord::Base
  belongs_to :person, :foreign_key => "owner"
  belongs_to :conversation
  has_many :comments, :class_name => 'ReflectionComment', :dependent => :destroy
  has_and_belongs_to_many :actions

  validates_presence_of :title
  validates_presence_of :details

  alias_attribute :participants, :owner

  attr_accessible :action_ids
  attr_accessible :title, :details, :conversation_id, :owner

  def owner_name
    self.person.name
  end

  def owner_participated_actions
    self.person.participated_actions
  end
end
