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
end