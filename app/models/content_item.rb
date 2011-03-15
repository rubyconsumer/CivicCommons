class ContentItem < ActiveRecord::Base


  CONTENT_TYPES = ["BlogPost", "NewsItem", "RadioShow", "Event", "Untyped"]
  belongs_to :person, :foreign_key => "author"

  validates_presence_of :title

end
