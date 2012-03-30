require 'spec_helper'

describe Reflection do
  describe "associations" do
    it { should belong_to :person }
    it { should belong_to :conversation }
    it { should have_and_belong_to_many :actions }
    it { should have_many :comments }
  end
end
