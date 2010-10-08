class Rating < ActiveRecord::Base
  belongs_to :person # who made this rating
  belongs_to :rateable, :polymorphic => true
  
  validates :rating, :numericality => true, :inclusion => { :in => [-1,1] }
  validates :rateable_id, :rateable_type, :presence => true
  validates :person, :must_be_logged_in => true
  
end
