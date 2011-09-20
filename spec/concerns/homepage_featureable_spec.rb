require 'spec_helper'

[Conversation].each do |model|
  describe model do
    it { should have_one(:homepage_featured) }

    it 'responds to "featured?" showing status of attachment to a HomepageFeatured object' do
      instance = Factory.create(model.to_s.downcase)
      instance.featured?.should be_false
      Factory.create(:homepage_featured, homepage_featureable: instance)
      instance.reload.featured?.should be_true
    end

    it 'provides a Class method for finding all objects associated with HomepageFeatured' do
      instance1 = Factory.create(model.to_s.downcase)
      instance2 = Factory.create(model.to_s.downcase)
      Factory.create(model.to_s.downcase)
      Factory.create(:homepage_featured, homepage_featureable: instance1)
      Factory.create(:homepage_featured, homepage_featureable: instance2)
      model.featured.all.should == [instance1, instance2]
    end
  end
end
