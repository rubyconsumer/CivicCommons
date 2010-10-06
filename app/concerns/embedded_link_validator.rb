class EmbeddedLinkValidator < ActiveModel::EachValidator
  
  def validate_each(record, attribute, value)
    record.errors[attribute] << "Link is not a valid URL" unless valid_url_format?(value)
    record.errors[attribute] << "Link could not be found" if @valid_url && !live_url?(value, record)
  end
  
  def valid_url_format?(value)
    require 'uri/http'
    begin
      uri = URI.parse(value)
      return @valid_url = case
      when uri.scheme.blank? || uri.host.blank?
        false 
      when !%w(http https).include?(uri.scheme)
        false
      else
        true
      end
    rescue
      return @valid_url = false
    end
  end
  
  def live_url?(value, record)
    if record.override_target_doc
      if record.override_url_exists.nil?
        record.errors[:base] << "You specified override_target_doc, but forgot to specify override_url_exists (since you're not testing the actual link, you gotta specify if it should be treated as valid)."
        return false
      elsif record.override_url_exists
        return true
      else
        return false
      end
    end
    require 'open-uri'
    begin
      open(CGI::unescapeHTML(value))
      return true
    rescue
      return false
    end
  end
  
  
end