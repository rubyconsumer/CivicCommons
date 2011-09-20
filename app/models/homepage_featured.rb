class HomepageFeatured < ActiveRecord::Base
  belongs_to :homepage_featureable, polymorphic: true
  validates_presence_of :homepage_featureable_id, :homepage_featureable_type
  validates_uniqueness_of :homepage_featureable_id, scope: :homepage_featureable_type
end