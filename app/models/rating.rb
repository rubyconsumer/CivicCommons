class Rating < ActiveRecord::Base
  belongs_to :person # who made this rating
  belongs_to :rateable, :polymorphic => true
  
  validates :rating, :numericality => true, :inclusion => { :in => [-1,0,1] }
  
end
