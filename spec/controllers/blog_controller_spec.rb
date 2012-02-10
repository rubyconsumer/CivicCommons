require 'spec_helper'

describe BlogController do
  
  def stub_radioshow(attributes = {})
    @radio_show ||= stub_model(ContentItem, attributes.merge({:content_type => 'RadioShow'})).as_null_object
  end
  def stub_blogpost(attributes = {})
    @blog_post ||= stub_model(ContentItem, attributes.merge({:content_type => 'BlogPost'})).as_null_object
  end
  
  describe "index" do
    before(:each) do
      ContentItem.stub!(:blog_authors)
    end
    it "should fetch all blog authors" do
      ContentItem.should_receive(:blog_authors)
      get :index
    end
    context "current author" do
      it "should get current_author if params[:author_id] exists" do
        Person.should_receive(:find).with(123)
        get :index, :author_id => 123
      end
      it "should NOT get current_author if params[:author_id] doesn't exists" do
        Person.should_not_receive(:find).with(123)
        get :index
      end
    end 
  end

end
