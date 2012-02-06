require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ConversationsHelper. For example:
# 
# describe ConversationsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ConversationsHelper do
  def mock_content_item(attributes={})
    @content_item ||= mock_model(ContentItem, attributes).as_null_object
  end
  
  describe "path_to_content_item" do
    it "should return radioshow path on radioshow content item" do
      helper.path_to_content_item(mock_content_item(:content_type => 'RadioShow',:id => 123)).should == radioshow_path(mock_content_item)
    end
    it "should return blog post path on blog post item" do
      helper.path_to_content_item(mock_content_item(:content_type => 'BlogPost',:id => 123)).should == blog_path(mock_content_item)
    end
  end
  
  describe "get_path_sym" do
    it "should return :radioshow on radioshow" do
      helper.get_path_sym(mock_content_item(:content_type => 'RadioShow',:id => 123)).should == :radioshow
    end
    it "should return :blog on blogpost" do
      helper.get_path_sym(mock_content_item(:content_type => 'BlogPost',:id => 123)).should == :blog
    end
  end
end
