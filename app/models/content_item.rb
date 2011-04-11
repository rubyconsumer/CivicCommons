class ContentItem < ActiveRecord::Base
  attr_accessor :url_slug

  CONTENT_TYPES = ["BlogPost", "NewsItem", "RadioShow", "Event", "Untyped"]
  belongs_to :person, :foreign_key => "author"

  validates_presence_of :title, :body
  validates_uniqueness_of :title

  has_friendly_id :url_slug_or_title, :use_slug => true, :strip_non_ascii => true

  def url_slug_or_title
    url_slug.blank? ? title : url_slug
  end
end
