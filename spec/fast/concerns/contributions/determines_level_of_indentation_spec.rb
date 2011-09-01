require 'fast/helper'

class TestDeterminesLevelOfIndentation
  include DeterminesLevelOfIndentation
  attr_accessor(:parent)
  def create_ancestral_tree_x_levels_deep(depth)
    return if depth == 0 
    @parent = TestDeterminesLevelOfIndentation.new
    @parent.create_ancestral_tree_x_levels_deep(depth-1)
  end
end

describe DeterminesLevelOfIndentation do
  let(:subject) { TestDeterminesLevelOfIndentation.new }
  context "with no ancestors" do
    it "Should be indented" do
      subject.should be_further_indented
    end
  end

  context "with 1 ancestor" do
    before { subject.create_ancestral_tree_x_levels_deep(1) }
    it "should be further indented" do
      subject.should be_further_indented
    end
  end

  context "with 2 ancestors" do
    before { subject.create_ancestral_tree_x_levels_deep(2) }
    it "should not be further indented" do
      subject.should_not be_further_indented
    end
  end

  context "with 5 ancestors" do
    before { subject.create_ancestral_tree_x_levels_deep(5) }
    it "should not be further indented" do
      subject.should_not be_further_indented
    end
  end
end
