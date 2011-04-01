require 'spec_helper'

# A mock for the Embedly service.
# WebMock requires us to know which URLs are called from within the gem.
# Is it better to mock the API interface or mock the API internals?
# This approach mocks the API.
class MockEmbedly

  def initialize(json)
    @json = json
  end

  def objectify(opts = {})
    return Array[self]
  end

  def marshal_dump
    EmbedlyService.parse_raw(@json)
  end

end

describe EmbedlyService do

  describe "EmbedlyService#fetch(url)" do

    context "Success" do

      it "should pass any options through to Embedly"

      it "retrieve embedly object given a valid YouTube url" do

        # These two lines use our internal mock
        json = fixture_content('embedly/youtube.json')
        embedly = EmbedlyService.new(MockEmbedly.new(json))
        
        # This line uses WebMock
        #embedly = EmbedlyService.new

        embedly.fetch('http://www.youtube.com/watch?v=onUd7aZhu9g')

        embedly.error.should be_nil
        embedly.properties.should_not be_nil

        embedly.properties.should have_key(:original_url)
        embedly.properties[:original_url].should == 'http://www.youtube.com/watch?v=onUd7aZhu9g'
        embedly.properties.should have_key(:url)
        embedly.properties[:url].should == 'http://www.youtube.com/watch?v=onUd7aZhu9g'
        embedly.properties.should have_key(:oembed)
        embedly.properties[:oembed].should be_instance_of Hash
      end

    end

    context "Unsuccessful" do

      #TODO Figure out how to mock the logger and test it
      it "return nil properties and log if embedly is down" do

        mock_embedly = mock('embedly')
        mock_embedly.stub(:objectify).and_raise(Exception)
        
        embedly = EmbedlyService.new(mock_embedly)
        embedly.fetch('http://www.youtube.com/watch?v=onUd7aZhu9g')
        embedly.properties.should be_nil
        embedly.error.should_not be_nil
      end

      #TODO Figure out how to mock the logger and test it
      it "return nil properties and log if embedly pro key is bad" do

        Civiccommons::Config.embedly['key'] = "garbage"
        mock_embedly = mock('embedly')
        mock_embedly.stub(:objectify).and_raise(Exception)
        
        embedly = EmbedlyService.new(mock_embedly)
        embedly.fetch('http://www.youtube.com/watch?v=onUd7aZhu9g')
        embedly.properties.should be_nil
        embedly.error.should_not be_nil
      end
      
      #TODO Figure out how to mock the logger and test it
      it "return an error if url is invalid" do

        json = fixture_content('embedly/bad_url.json')
        embedly = EmbedlyService.new(MockEmbedly.new(json))

        embedly.fetch('garbage url')
        embedly.properties.should be_nil
        embedly.error.should_not be_nil
      end
    
    end

    # This set of tests exists simply to verify the accuracy of our fixtures
    # These tests should not be run normally, they are very slow and depend
    # on a live connection to embedly
    #context "Live connection to Embedly" do

      #before(:all) do
        #WebMock.allow_net_connect!
      #end

      #after(:all) do
        #WebMock.disable_net_connect!
      #end

      #let(:embedly) { EmbedlyService.new }

      #it "retrieve embedly object given a valid YouTube url" do
        #embedly.fetch('http://www.youtube.com/watch?v=onUd7aZhu9g')
        #embedly.properties.should have_key(:original_url)
        #embedly.fetch('http://www.youtube.com/watch?v=onUd7aZhu9g&some=other&garbage=data')
        #embedly.properties.should have_key(:url)
        #embedly.properties[:url].should == 'http://www.youtube.com/watch?v=onUd7aZhu9g'
        #embedly.properties.should have_key(:oembed)
        #embedly.properties[:oembed].should be_instance_of Hash
        #embedly.error.should be_nil
      #end

      #it "retrieve embedly object given a valid Flickr url" do
        #pending
        #embedly.fetch('http://www.flickr.com/photos/civiccommons/5387288109/in/set-72157625550814356/')
        #fixture_content('embedly/flickr.json')
      #end

      #it "retrieve embedly object given a valid Twitpic url" do
        #pending
        #embedly.fetch('http://www.twitpic.com/4eatzr')
        #fixture_content('embedly/twitpic.json')
      #end

      #it "retrieve embedly object given a valid Facebook photo  url" do
        #pending
        #embedly.fetch('https://www.facebook.com/photo.php?fbid=193403794003481&set=a.193403500670177.49699.143930632284131&theater')
        #fixture_content('embedly/facebook_photo.json')
      #end

      #it "retrieve embedly object given a valid Facebook video url" do
        #pending
        #embedly.fetch('http://www.facebook.com/video/video.php?v=10150467656635175')
        #fixture_content('embedly/facebook_video.json')
      #end

      #it "retrieve embedly object given a valid Google Map url" do
        #pending
        #embedly.fetch('http://maps.google.com/maps?f=q&source=s_q&hl=en&geocode=&q=1360+East+Ninth+Street,+Suite+210,+Cleveland,+OH+44114&aq=&sll=41.510184,-81.690967&sspn=0.008243,0.019205&ie=UTF8&hq=&hnear=1360+E+9th+St+%23210,+Cleveland,+Cuyahoga,+Ohio+44114&ll=41.503451,-81.690087&spn=0.008244,0.019205&t=h&z=16')
        #fixture_content('embedly/google_maps.json')
      #end

      #it "retrieve embedly object given a valid Unknown provider url" do
        #pending
        #embedly.fetch('http://www.youtube.com/watch?v=onUd7aZhu9g')
        #fixture_content('embedly_example_youtube.json')
      #end

    #end

  end

end
