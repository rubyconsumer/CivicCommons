module HomepageFeaturable
  def self.included(base)
    base.has_one :homepage_featured, as: :homepage_featureable
    base.extend(Scopes)
  end

  def featured?
    not self.homepage_featured.nil?
  end

  module Scopes
    def featured
      includes(:homepage_featured).where('homepage_featureds.homepage_featureable_id IS NOT NULL')
    end
  end
end