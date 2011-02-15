require 'spec_helper'

[Link, EmbeddedSnippet].each do |model|
  describe model, "When working with links" do
    before(:each) do
      @model = Factory.build(model.to_s.underscore)
    end
    
    context "and checking validity of the link URL" do
      it "should have no errors for a valid url" do
        @model.valid?.should be_true
      end
      it "throws an error for an invlid URL format" do
        @model.url = "an invalid url format"
        @model.should have_validation_error(:url, /Link is not a valid URL/)
      end
      it "throws an error for a URL that doesn't exist", :wip => true do
        @model.url = "http://www.example.com/this-page-does-not-exist"
        @model.should have_validation_error(:url, /Link could not be found/)
      end
    end
    
    describe "and importing information about the link" do
      before(:each) do
        # @model.run_callbacks(:save) # this does not work with awesome_nested_set apparently
        @model.save!
      end
      it "finds the target document" do
        @model.target_doc.should_not be_blank
      end
      if model == Link
        it "grabs the correct title" do
          @model.title.should_not be_blank
          @model.title.should match /Pure-CSS Emoticons WordPress Plugin Released - Alfa Jango Blog/
        end
        it "grabs the first paragraph as the description if no meta-description is present" do
          #@model.description.should_not be_blank
          #@model.description.should match /I'll keep this post short and sweet. My good friend, Anthony Montalbano, has released a WordPress plugin for our/
          # This spec has changed. Because of PA links which wrap navigation elements in paragraph tags,
          # we now want to simply leave the description blank if there's no meta-description
          @model.description.should be_blank
        end
      end
      if model == EmbeddedSnippet
        it "strips whitespace from title that includes whitepsace" do
          @model.title.should_not be_blank
          @model.title.should match /YouTube - LeadNuke Demo Screencast/
        end
        it "grabs the meta-description as the description if available" do
          @model.description.should_not be_blank
          @model.description.should match /Introduction to LeadNuke.com, featuring demonstration showing how RateMyStudentRental.com uses LeadNuke to increase sales./
        end
      end
    end
  end
end
