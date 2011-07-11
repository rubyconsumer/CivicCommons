require 'digest'
require 'net/http'
require 'uri'

class AvatarService

  def self.avatar_url(person)
    unless person.authentications.empty?
      self.facebook_url(person)
    end
  end

  def self.facebook_url(person)
    facebook_id = person.authentications.first.uid
    "http://graph.facebook.com/#{facebook_id}/picture"
  end

end
