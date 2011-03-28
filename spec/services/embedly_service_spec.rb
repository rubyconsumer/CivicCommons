require 'spec_helper'

describe EmbedlyService do

  before(:all) do
    WebMock.allow_net_connect!
  end

  after(:all) do
    WebMock.disable_net_connect!
  end

  describe "EmbedlyService#fetch(url)" do

    context "Successful" do

      let(:embedly) { EmbedlyService.new }

      it "retrieve embedly object given a valid YouTube url" do
        embedly.fetch('http://www.youtube.com/watch?v=onUd7aZhu9g')
        embedly.properties.should have_key(:original_url)
        embedly.properties[:original_url].should == 'http://www.youtube.com/watch?v=onUd7aZhu9g'
      end

      it "retrieve embedly object given a valid Flickr url" do
        pending
        embedly.fetch('http://www.flickr.com/photos/civiccommons/5387288109/in/set-72157625550814356/')
        embedly.properties.should == fixture_content('embedly/flickr.json')
      end

      it "retrieve embedly object given a valid Twitpic url" do
        pending
        embedly.fetch('http://www.twitpic.com/4eatzr')
        embedly.properties.should == fixture_content('embedly/twitpic.json')
      end

      it "retrieve embedly object given a valid Facebook photo  url" do
        pending
        embedly.fetch('https://www.facebook.com/photo.php?fbid=193403794003481&set=a.193403500670177.49699.143930632284131&theater')
        embedly.properties.should == fixture_content('embedly/facebook_photo.json')
      end

      it "retrieve embedly object given a valid Facebook video url" do
        pending
        embedly.fetch('http://www.facebook.com/video/video.php?v=10150467656635175')
        embedly.properties.should == fixture_content('embedly/facebook_video.json')
      end

      it "retrieve embedly object given a valid Google Map url" do
        pending
        embedly.fetch('http://maps.google.com/maps?f=q&source=s_q&hl=en&geocode=&q=1360+East+Ninth+Street,+Suite+210,+Cleveland,+OH+44114&aq=&sll=41.510184,-81.690967&sspn=0.008243,0.019205&ie=UTF8&hq=&hnear=1360+E+9th+St+%23210,+Cleveland,+Cuyahoga,+Ohio+44114&ll=41.503451,-81.690087&spn=0.008244,0.019205&t=h&z=16')
        embedly.properties.should == fixture_content('embedly/google_maps.json')
      end

      it "retrieve embedly object given a valid Unknown provider url" do
        pending
        embedly.fetch('http://www.youtube.com/watch?v=onUd7aZhu9g')
        embedly.properties.should == fixture_content('embedly_example_youtube.json')
      end

    end

    context "Unsuccessful" do
      it "return an error if embedly is down"
      it "return an error if url is invalid"
      it "return an error when url does not resolve"
    end
  end

end
