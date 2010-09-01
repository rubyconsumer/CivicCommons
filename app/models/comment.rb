require 'parent_validator'

class Comment < ActiveRecord::Base
  include Rateable
  include Visitable
  
  belongs_to :person, :foreign_key=>"owner"
  belongs_to :conversation
  
  acts_as_tree :foreign_key => 'comment_id'
    
  validates :content, :presence=>true 
  validates_associated :conversation, :parent
       
end