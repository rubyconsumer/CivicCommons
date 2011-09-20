require 'spec_helper'

describe HomepageFeatured do
  it { should belong_to(:homepage_featureable) }
  it { should have_db_index([:homepage_featureable_id, :homepage_featureable_type]).unique(true) }
  it { should validate_presence_of(:homepage_featureable_id) }
  it { should validate_presence_of(:homepage_featureable_type) }

  context 'factories' do
    it 'is valid' do
      Factory.build(:homepage_featured).should be_valid
      Factory.create(:homepage_featured).should be_valid
    end
  end

  context 'creation' do
    it 'should not allow entries with duplicate homepage_featureable' do
      Factory.create(:homepage_featured)
      should validate_uniqueness_of(:homepage_featureable_id).scoped_to(:homepage_featureable_type)
    end
  end

  context 'deletion' do
    it 'should not delete the homepage_featureable object if the HomepageFeature object is deleted' do
      homepage_featured = Factory.create(:homepage_featured)
      homepage_featureable = homepage_featured.homepage_featureable
      homepage_featured.destroy
      homepage_featureable.reload.should be_valid
    end
  end
end