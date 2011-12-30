module ProfileHelper
  CUSTOM_CLASSES = {
    email: "email-profile",
    twitter: "twitter-profile",
    address: "website-profile",
    facebook: "fb-profile"
  }
  DATA_TO_FOLD_INTO_ADDRESS = [:phone, :website]
  def contact_info_for profile
    data = fold_address_together(profile.profile_data)
    data.reject! { |k, v| v.empty? }
    data.inject("") do | list, (type, data) |
      list << "<li#{class_for(type)}>#{prep(data, type)}</li>"
    end
  end

  private

  def fold_address_together data
    address_parts = []
    address_parts.push(data[:address]) if data[:address]
    DATA_TO_FOLD_INTO_ADDRESS.each do |type|
      if data.has_key? type
        address_parts.push("#{prep(data[type], type)}")
        data.reject! { |(k,v)| k == type }
      end
    end
    address_parts.push("#{prep(data[:website], :website)}") if data[:website]
    data[:address] = address_parts.join('<br />');
    data
  end
  def class_for type
    return " class=\"#{CUSTOM_CLASSES[type]}\"" if CUSTOM_CLASSES.has_key? type
  end
  def prep data, type
    data.gsub! /\n/, "<br />"
    return link_to(data, 'mailto:' + data) if type == :email
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
