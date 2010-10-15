require 'spec_helper'

describe Contribution do
  before(:each) do
    @article = Factory.build(:article)
  end
  it "is valid" do
    @article.should be_valid
  end
end