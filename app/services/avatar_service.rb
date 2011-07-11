require 'digest'
require 'net/http'
require 'uri'

class AvatarService

  def self.avatar_url(person)
    if !person.authentications.empty?
      self.facebook_image_url(person)
    elsif person.twitter_username
      self.twitter_image_url(person)
    end
  end

  def self.facebook_image_url(person)
    facebook_id = person.authentications.first.uid
    "http://graph.facebook.com/#{facebook_id}/picture"
  end

  def self.twitter_image_url(person)
    "http://api.twitter.com/1/users/profile_image/#{person.twitter_username}"
  end

end
