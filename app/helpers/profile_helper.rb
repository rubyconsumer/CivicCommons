module ProfileHelper
  CUSTOM_CLASSES = {
    twitter: "twitter-profile",
    website: "website-profile",
    facebook: "facebook-profile"
  }
  def contact_info_for profile
    data = profile.profile_data.reject { |k, v| v.empty? }
    data.inject("") do | list, (type, data) |
      list << "<li#{class_for(type)}>#{prep_data(data, type)}</li>"
    end
  end

  private
  def class_for type
    return " class=\"#{CUSTOM_CLASSES[type]}\"" if CUSTOM_CLASSES.has_key? type
  end
  def prep_data data, type
    return twitter_url(data) if type == :twitter
    return link_to("Website", data) if type == :website
    return link_to("Facebook", data) if type == :facebook
    return "P: #{data}" if type == :phone
    data
  end
  def twitter_url(handle)
    link_to "@#{handle}", "http://twitter.com/#!/#{handle}"
  end
end
