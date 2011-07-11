require 'spec_helper'

module Services
  describe AvatarService do

    context "Determining avatar url" do

      it "When a person has linked their Facebook account, returns a FB graph url" do
        person = Factory.create(:registered_user)
        person.stub_chain(:authentications, :empty?).and_return(false)
        person.stub_chain(:authentications, :first, :uid).and_return(1)
        avatar_url = AvatarService.avatar_url(person)
        avatar_url.should == "http://graph.facebook.com/1/picture"
      end

      it "When a person has not linked their Facebook account, but the person has entered a Twitter Username, returns Twitter url"
      it "When a person does not have FB linked, or a Twitter username, checks if the user has a gravatar for their email, returns Gravatar url"
      it "When a person does not have a FB linked, Twitter username, or Gravatar, defaults to the local CC avatar"

    end

    context "Updating person's avatar url" do

      it "Saves the url for the person"

    end

  end
end
