class ContentItem < ActiveRecord::Base
  attr_accessor :url_slug

  CONTENT_TYPES = ["BlogPost", "NewsItem", "RadioShow", "Untyped"]

  belongs_to :author, :class_name => "Person", :foreign_key => "person_id"

  validates_presence_of :title, :body, :author
  validates_uniqueness_of :title
  validates_presence_of :embed_code, :if => :content_type_is_radio_show?

  validates :published, :date => {:after => Proc.new { Time.now - 1.year} }

  has_friendly_id :url_slug_or_title, :use_slug => true, :strip_non_ascii => true

private

  def content_type_is_radio_show?
    content_type == "RadioShow"
  end

  def url_slug_or_title
    url_slug.blank? ? title : url_slug
  end

end
