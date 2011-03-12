class ContentItem < ActiveRecord::Base


  ALL_TYPES = ["BlogPost", "NewsItem", "RadioShow", "Event", "Untyped"]
  belongs_to :person, :foreign_key => "author"

end
