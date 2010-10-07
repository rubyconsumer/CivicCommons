class County < ActiveRecord::Base

  validates_presence_of :name 
  validates_presence_of :state 
  validates_length_of :state, :maximum=>2

end
