require 'spec_helper'

describe MetroRegion do
  context "Associations" do
    it { should have_many :conversations}
  end
end
