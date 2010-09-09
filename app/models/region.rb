class Region < ActiveRecord::Base
  
  has_many :zip_codes
  accepts_nested_attributes_for :zip_codes
  
end
