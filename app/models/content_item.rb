class ContentItem < ActiveRecord::Base
  attr_accessor :url_slug

  CONTENT_TYPES = ["BlogPost", "NewsItem", "RadioShow"]

  belongs_to :author, :class_name => "Person", :foreign_key => "person_id"

  validates_presence_of :title, :body, :author
  validates_presence_of :external_link, :if => :content_type_is_news_item?
  validates_format_of :external_link, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :allow_blank => true
  validates_uniqueness_of :title

  validates :published, :date => {:after => Proc.new { Time.now - 1.year} }

  has_friendly_id :url_slug_or_title, :use_slug => true, :strip_non_ascii => true

  def url_slug_or_title
    url_slug.blank? ? title : url_slug
  end

  def content_type_is_news_item?
    content_type == "NewsItem"
  end
end
