class Reflection < ActiveRecord::Base
  belongs_to :person, :foreign_key => "owner"
  belongs_to :conversation
  has_many :reflection_petitions, :dependent => :destroy
  has_many :petitions, :through => :reflection_petitions
  #has_many :petitions, :dependent => :destroy

  validates_presence_of :title
  validates_presence_of :details

  alias_attribute :participants, :owner

  accepts_nested_attributes_for :petitions, :allow_destroy => true
  attr_accessible :petitions_attributes
  attr_accessible :petition_ids
  attr_accessible :title, :details, :conversation_id, :owner
end
