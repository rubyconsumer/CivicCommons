require 'parent_validator'
require 'rating_validator'

class Rating < ActiveRecord::Base
  include ActiveModel::Validations
  belongs_to :person # who made this rating
  belongs_to :postable, :polymorphic => true
  validates_with RatingValidator
end
