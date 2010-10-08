module PAAuthHelper
  def pa_authtoken(prepend = nil)
    "#{prepend}authToken=#{cookies[:pa_auth_token]}" unless cookies[:pa_auth_token].blank?
  end
end
