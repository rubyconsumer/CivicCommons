class HomepageFeatured < ActiveRecord::Base
  belongs_to :homepage_featureable, polymorphic: true
  validates_presence_of :homepage_featureable_id, :homepage_featureable_type
  validates_uniqueness_of :homepage_featureable_id, scope: :homepage_featureable_type
  delegate :image, :title, to: :homepage_featureable

  # Returns back a minimium of the desired homepage feature items that is not in the filter.
  #
  # Might return back an empty array if the desired number is not available.
  def self.min_sample(limit=10, filter = [])
    filter = [filter] unless filter.respond_to?(:flatten)
    filter.flatten!
    featured = self.all
    samples = []

    unless samples.size >= limit
      samples = featured.sample(limit + 2)
      samples = samples.select{|sample| !(([sample.homepage_featureable] - filter)).blank?}
      samples.compact!
    end

    samples
  end
end
