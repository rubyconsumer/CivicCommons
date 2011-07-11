require 'digest'
require 'net/http'
require 'uri'

class AvatarService

  def self.avatar_image_url(person)
    if !person.authentications.empty?
      self.facebook_image_url(person)
    elsif person.twitter_username
      self.twitter_image_url(person)
    elsif self.gravatar_available?(person)
      self.gravatar_image_url(person)
    else
      person.avatar.url(:standard)
    end
  end

  def self.facebook_image_url(person)
    facebook_id = person.authentications.first.uid
    "http://graph.facebook.com/#{facebook_id}/picture"
  end

  def self.twitter_image_url(person)
    "http://api.twitter.com/1/users/profile_image/#{person.twitter_username}"
  end

  def self.gravatar_available?(person)

    gravatar_response = Net::HTTP.get_response(URI.parse(gravatar_image_url(person)))

    unless gravatar_response.class == Net::HTTPNotFound
      true
    else
      false
    end

  end

  def self.gravatar_image_url(person)
    hashed_email = self.create_email_hash(person)
    "http://gravatar.com/avatar/#{hashed_email}?d=404"
  end

  def self.create_email_hash(person)
    Digest::MD5.hexdigest(person.email)
  end

  def self.update_person(person)
    person.update_attributes(avatar_url: self.avatar_image_url(person))
  end

end
