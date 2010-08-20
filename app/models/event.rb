class Event < ActiveRecord::Base
  include Rateable
  
  has_and_belongs_to_many :conversations
  has_and_belongs_to_many :guides, :class_name => 'Person', :join_table => 'events_guides'
  belongs_to :creator, :class_name => 'Person'
  belongs_to :moderator, :class_name => 'Person'  
  belongs_to :postable, :polymorphic => true
  has_many :posts, :as => :conversable  
  
  validates :title, :presence=>true
  validates :where, :presence=>true
end
