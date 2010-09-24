class EmbeddedLinkValidator < ActiveModel::EachValidator
  
  def validate_each(record, attribute, value)
    record.errors[attribute] << "could not be found" unless live_url?(value)
    record.errors[attribute] << "is not a valid URL" unless valid_url_format?(value)
  end
  
  def valid_url_format?(value)
    require 'uri/http'
    begin
      uri = URI.parse(value)
      return false if uri.scheme.blank? || uri.host.blank?
      return false unless %w(http https).include?(uri.scheme)
      return true
    rescue
      return false
    end
  end
  
  def live_url?(value)
    require 'open-uri'
    begin
      open(CGI::unescapeHTML(value))
      return true
    rescue
      return false
    end
  end
  
  
end