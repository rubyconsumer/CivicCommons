class ContentItemDescription < ActiveRecord::Base
  validates :content_type, :presence => true, :uniqueness => true, :inclusion => ['RadioShow']
  validates :description_long, :presence => true
  validates :description_short, :presence => true

  scope :radio_show, lambda {where(:content_type => "RadioShow")}
end
