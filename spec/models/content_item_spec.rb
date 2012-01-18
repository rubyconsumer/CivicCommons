require 'spec_helper'

describe ContentItem do

  before(:all) do
    @author = Factory.build(:admin_person)
  end

  before(:each) do
    @content_item = Factory.build(:content_item,:author => @author)
  end

  context "validations" do

    it "creates a valid object" do
      @content_item.should be_valid
    end

    it "validates the presence of title" do
      @content_item.title = nil
      @content_item.should_not be_valid
    end

    it "validates the presence of body" do
      @content_item.body = nil
      @content_item.should_not be_valid
    end

    it "validates the presence of published" do
      @content_item.published = nil
      @content_item.should_not be_valid
    end

    it "validates the presence of author" do
      @content_item.author = nil
      @content_item.should_not be_valid
    end

    it "validates the uniqueness of the title" do
      @content_item.save
      @content_item2 = Factory.build(:content_item, :title => @content_item.title)
      @content_item2.should_not be_valid
    end

    it "validates the presence of an external link for a news item" do
      @content_item.content_type = 'NewsItem'
      @content_item.external_link = nil
      @content_item.should_not be_valid
    end
    
    it 'requires one topic to be assigned' do
      content_item = Factory.build(:blog_post, topics: [])
      content_item.should_not be_valid

      topic = Factory.build(:topic)
      content_item.topics = [topic]
      content_item.should be_valid
    end

  end

  context "has_and_belongs_to_many topics" do
    describe "on blog posts" do
      def given_a_blog_post_with_topics
        @topic1 = Factory.create(:topic)
        @topic2 = Factory.create(:topic)
        @blog = Factory.create(:blog_post)
        @blog.topics = [@topic1, @topic2]
      end
      it "should be correct" do
        ContentItem.reflect_on_association(:topics).macro.should == :has_and_belongs_to_many
      end
      it "should correctly count the number of topics" do
        given_a_blog_post_with_topics
        @blog.topics.count.should == 2
      end
    end

    describe "on radio shows" do
      def given_a_radio_show_with_topics
        @topic1 = Factory.create(:topic)
        @topic2 = Factory.create(:topic)
        @radio_show = Factory.create(:radio_show)
        @radio_show.topics = [@topic1, @topic2]
      end
      it "should be correct" do
        ContentItem.reflect_on_association(:topics).macro.should == :has_and_belongs_to_many
      end
      it "should correctly count the number of topics" do
        given_a_radio_show_with_topics
        @radio_show.topics.count.should == 2
      end
    end
  end

  context "custom finders" do

    context "recent_blog_posts" do

      before(:each) do
        @p1 = Factory.create(:admin_person)
        @p2 = Factory.create(:admin_person)
        @b1_1 = Factory.create(:blog_post, author: @p1, published: 1.day.ago, created_at: 1.day.ago)
        @b2_1 = Factory.create(:blog_post, author: @p2, published: 2.days.ago, created_at: 2.days.ago)
        @b2_2 = Factory.create(:blog_post, author: @p2, published: 2.days.ago, created_at: 3.days.ago)
        @b2_3 = Factory.create(:blog_post, author: @p2, published: 3.day.ago, created_at: 3.days.ago)
      end

      it "retrieves all blog posts sorted properly when no author is given" do
        blogs = ContentItem.recent_blog_posts
        blogs.first.id = @b1_1.id
        blogs.last.id = @b2_3.id
      end

      it "retrieves all blog posts by one author sorted properly when author id given" do
        blogs = ContentItem.recent_blog_posts(@p2.id)
        blogs.first.id = @b2_1.id
        blogs.last.id = @b2_3.id
      end

      it "retrieves all blog posts by one author sorted properly when author Person is given" do
        blogs = ContentItem.recent_blog_posts(@p2)
        blogs.first.id = @b2_1.id
        blogs.last.id = @b2_3.id
      end

    end

  end

  context "urls" do
    it "will show the correct path for a BlogPost" do
      blog_post = Factory.build(:blog_post)
      blog_post.url.should == blog_path(blog_post)
    end

    it "will show the correct path for a RadioShow" do
      radio_show = Factory.build(:radio_show)
      radio_show.url.should == radioshow_path(radio_show)
    end

    it "will show the external link for a NewsItem" do
      news_item = Factory.build(:news_item)
      news_item.url.should == news_item.external_link
    end
  end

  context "paperclip" do
    it "will have necessary db columns for paperclip" do
      should have_db_column(:image_file_name).of_type(:string)
      should have_db_column(:image_content_type).of_type(:string)
      should have_db_column(:image_file_size).of_type(:integer)
    end

    it "will only allow image attachments" do
      # allowed image mimetypes are based on what we have seen in production
      should validate_attachment_content_type(:image).
        allowing('image/bmp', 'image/gif', 'image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png').
        rejecting('text/plain', 'text/xml')
    end

    it "will have an existing default image" do
      paperclip_default_file_exists?('original').should be_true
      ContentItem.attachment_definitions[:image][:styles].each do |style, size|
        paperclip_default_file_exists?(style.to_s).should be_true
      end
    end

    def paperclip_default_file_exists?(style)
      default_url = ContentItem.attachment_definitions[:image][:default_url].gsub(/\:style/, style)
      default_file = File.join(Rails.root, 'public', default_url)
      File.exist?(default_file)
    end

  end

end
