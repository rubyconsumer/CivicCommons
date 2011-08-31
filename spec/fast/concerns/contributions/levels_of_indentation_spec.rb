require 'fast/helper'

class TestDeterminesLevelOfIndentation
  include DeterminesLevelOfIndentation
  attr_accessor(:parent)
end
describe DeterminesLevelOfIndentation do
  let(:subject) { TestDeterminesLevelOfIndentation.new }
  context "with no ancestors" do
    before { subject.stub!(:number_of_ancestors).and_return 0 }
    it "Should be 0" do
      subject.level_of_indentation.should == 0
    end
  end

  context "with 1 ancestor" do
    before { subject.stub!(:number_of_ancestors).and_return 1 }
    it "should be 1" do
      subject.level_of_indentation.should == 1
    end
  end

  context "with 2 ancestors" do
    before { subject.stub!(:number_of_ancestors).and_return 2 }
    it "should be 2" do
      subject.level_of_indentation.should == 2
    end
  end

  context "with 5 ancestors" do
    before { subject.stub!(:number_of_ancestors).and_return 5 }
    it "should be 2" do
      subject.level_of_indentation.should == 2
    end
  end
  describe "finding number of ancestors" do
    describe "Finding how many ancestors a record has" do
      context "when it has no parent" do
        it "has 0 ancestors" do
          subject.number_of_ancestors.should == 0
        end
      end

      context "when it has a parent" do
        it "has a 1 ancestor" do
          subject.parent = TestDeterminesLevelOfIndentation.new 
          subject.number_of_ancestors.should == 1
        end
      end

      context "when it has a parent with a parent" do
        it "has a 2 ancestors" do
          subject.parent = TestDeterminesLevelOfIndentation.new 
          subject.parent.parent = TestDeterminesLevelOfIndentation.new 
          subject.number_of_ancestors.should == 2
        end
      end
    end
  end
end
