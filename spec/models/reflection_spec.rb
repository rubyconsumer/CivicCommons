require 'spec_helper'

describe Reflection do
  describe "factories" do
    it { Factory.build(:reflection).should be_valid }
    it { Factory.create(:reflection).should be_valid }
  end

  describe "associations" do
    it { should belong_to :person }
    it { should belong_to :conversation }
    it { should have_and_belong_to_many :actions }
    it { should have_many :comments }
  end
end
