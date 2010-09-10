class Issue < ActiveRecord::Base
  include Rateable
  include Visitable
  include TopItemable
  
  belongs_to :person
  has_and_belongs_to_many :conversations
  
  validates :description, :presence => true, :length => { :minimum => 5 }  
   
end
