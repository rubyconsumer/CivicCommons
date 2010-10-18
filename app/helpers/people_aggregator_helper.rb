require 'uri'

module PeopleAggregatorHelper
  def pa_authtoken(prepend = nil)
    "#{prepend}authToken=#{CGI.escape(cookies[:pa_auth_token])}" unless cookies[:pa_auth_token].blank?
  end
  
  def append_pa_authtoken(url)
    uri = URI.parse(url) 
    if uri.query.blank?
      "#{url}#{pa_authtoken('?')}"
    else
      "#{url}#{pa_authtoken('&')}"
    end
  end
  
  def format_params(params={})
    params = params.map do |name, value|
      "#{name}=#{value}"
    end
    
    params.blank? ? nil : "?#{params.join("&")}"
  end
  
  def pa_link(destination = nil, params={})
    params = format_params(params)
    append_pa_authtoken( "#{Civiccommons::PeopleAggregator.URL}/#{destination}#{params}" )
  end
  
end
