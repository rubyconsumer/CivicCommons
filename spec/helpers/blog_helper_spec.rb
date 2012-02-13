require 'spec_helper'
include AvatarHelper
describe BlogHelper do
  
  def mock_blog(attributes={})
    @blog_post ||= mock_model(ContentItem,{:content_type=>'BlogPost'}.merge(attributes)).as_null_object
  end
  def mock_person(attributes={})
    mock_model(Person,{:avatar_url => 'avatar.jpg'}.merge(attributes)).as_null_object
  end
  
  describe "blog_filter_by_author_link" do
    it "should show the correct link" do
      author = mock_person(:name => 'John Author', :id => 123)
      current_author = mock_person(:name => 'John CurrentAuth', :id => 1234)
      helper.blog_filter_by_author_link(author,current_author).should == "<a href=\"/blog?author_id=123\" class=\"\"><img alt=\"John Author\" class=\"mem-img\" height=\"16\" src=\"/images/avatar.jpg\" title=\"John Author\" width=\"16\" /><span>John Author</span></a>"
    end
    it "should show 'active' when author is the same as current_author" do
      author = mock_person(:name => 'John Author', :id => 123)
      current_author = author
      helper.blog_filter_by_author_link(author,current_author).should == "<a href=\"/blog\" class=\"active\"><img alt=\"John Author\" class=\"mem-img\" height=\"16\" src=\"/images/avatar.jpg\" title=\"John Author\" width=\"16\" /><span>John Author</span></a>"
    end
  end
end
