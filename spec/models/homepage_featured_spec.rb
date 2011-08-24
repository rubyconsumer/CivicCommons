require 'spec_helper'

describe HomepageFeatured do
  context 'factories' do
    it 'is valid' do
      Factory.build(:homepage_featured).should be_valid
      Factory.create(:homepage_featured).should be_valid
    end
  end
end