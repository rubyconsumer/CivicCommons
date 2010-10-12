require 'spec_helper'

[EmbeddedSnippet].each do |model|
  describe model.to_s, "When working with YouTube videos" do
    before(:each) do
      @model = Factory.build(model.to_s.underscore.to_sym)
    end
    
    context "and submitting a URL" do
      [ "http://www.example.com/this-is-not-a-valid-youtube-url" ].each do |invalid_youtube_url|
        invalid_youtube_url_format = invalid_youtube_url =~ /(http:\/\/www.youtube.com)?(.*)/; $2;
        
        pending "throws an error if URL is not a valid YouTube URL with the format #{invalid_youtube_url_format}" do
          @model.url = invalid_youtube_url
          @model.valid?.should be_false
          @model.should have_validation_error(:url, /Link is not a valid YouTube URL/)
        end
      end
      [ "http://www.youtube.com/watch?v=djtNtt8jDW4", 
        "http://www.youtube.com/watch?v=G75KhTQWyDA&feature=related" ].each do |valid_youtube_url|
        valid_youtube_url_format = valid_youtube_url =~ /(http:\/\/www.youtube.com)?(.*)/; $2;
        
        it "saves successfully if URL is a valid YouTube URL with the format #{valid_youtube_url_format}" do
          @model.url = valid_youtube_url
          @model.valid?.should be_true
        end
      end
    end
    
    context "and setting the embed code" do
      it "properly sets the embed code" do
        @model.save
        @model.embed_target.should_not be_blank
        @model.embed_target.should match /(djtNtt8jDW4)+/
      end
      it "updates the embed code if the url is updated" do
        @model.url = "http://www.youtube.com/watch?v=abcDef0gHI1"
        @model.save
        @model.embed_target.should match /(abcDef0gHI1)+/
      end
    end
  end
end