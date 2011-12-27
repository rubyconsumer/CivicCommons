require 'spec_helper'

describe Organization do

  subject { Factory.create(:organization, name: 'The Civic Commons') }

  let(:user) {Factory.create(:normal_person)}
  let(:allowed_image_types) {["image/gif", "image/jpeg", "image/png", "image/bmp"]}

  it { should be_valid }
  it { subject.organization_detail.should_not be_blank }
  it { should have_attached_file :avatar }
  it { should validate_attachment_content_type(:avatar).allowing(allowed_image_types).rejecting(['text/plain']) }

  context "validation" do
    it "should validate on name" do
      org = Factory.build(:organization, :name=>'')
      org.valid?
      org.errors[:name].should == ["can't be blank"]
    end

    it "should not validate first_name and last_name" do
      org = Factory.build(:organization, :first_name=>'', :last_name => '')
      org.valid?
      org.errors[:first_name].should be_blank
      org.errors[:last_name].should be_blank
    end
  end

  context "Inheritance" do
    it "should be a subclass of Person" do
      Organization.superclass.should == Person
    end
  end

  context "Associations" do
    it "should have organization details" do
      Organization.reflect_on_association(:organization_detail).macro == :has_one
    end
  end

  context "defaults" do
    it "should have allow_facebook_connect? to be false always" do
      Organization.new.allow_facebook_connect?.should be_false
    end
  end

  context "subscription" do
    it 'is created by calling subscribe' do
      subscription = subject.subscribe(user)
      subscription.subscribable.name.should == 'The Civic Commons'
    end
  end

end
