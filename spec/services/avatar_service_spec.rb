require 'spec_helper'

module Services

  describe AvatarService do

    before(:each) do
      @person = Factory.create(:registered_user, :twitter_username => "civiccommons")
    end

    context "Determining avatar url" do


      it "When a person has linked their Facebook account, returns a FB graph url" do
        @person.stub_chain(:authentications, :empty?).and_return(false)
        @person.stub_chain(:authentications, :first, :uid).and_return(1)
        avatar_url = AvatarService.avatar_image_url(@person)
        avatar_url.should == "https://graph.facebook.com/1/picture"
      end

      it "When a person has not linked their Facebook account, but the person has entered a Twitter Username, returns Twitter url" do
        @person.stub_chain(:authentications, :empty?).and_return(true)
        avatar_url = AvatarService.avatar_image_url(@person)
        avatar_url.should == "http://api.twitter.com/1/users/profile_image/civiccommons"
      end

      it "When a person does not have FB linked, or a Twitter username, checks if the user has a gravatar for their email, returns Gravatar url" do
        @person.update_attributes(:twitter_username => nil)
        AvatarService.should_receive(:gravatar_available?).and_return(true)
        AvatarService.should_receive(:create_email_hash).and_return(5)
        avatar_url = AvatarService.avatar_image_url(@person)
        avatar_url.should == "http://gravatar.com/avatar/5?d=404"
      end

      it "When a person does not have a FB linked, Twitter username, or Gravatar, defaults to the local CC avatar" do
        @person.update_attributes(:twitter_username => nil)
        AvatarService.should_receive(:gravatar_available?).and_return(false)
        avatar_url = AvatarService.avatar_image_url(@person)
        avatar_url.should match(/images/)
      end

    end

    context "Updating person's avatar url" do

      it "Saves the url for the person" do
        AvatarService.update_avatar_url_for(@person)
        @person.reload
        @person.avatar_url.should == AvatarService.avatar_image_url(@person)
      end

    end

  end
end
