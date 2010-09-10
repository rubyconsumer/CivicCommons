class Event < ActiveRecord::Base
  include Rateable
  include Visitable
  include TopItemable
    
  has_and_belongs_to_many :conversations
  has_and_belongs_to_many :guides, :class_name => 'Person', :join_table => 'events_guides'
  belongs_to :creator, :class_name => 'Person'
  belongs_to :moderator, :class_name => 'Person'  
  
  validates :title, :presence=>true
  validates :where, :presence=>true
end
