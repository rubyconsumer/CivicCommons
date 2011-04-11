module AuthenticationHelper
  def unlink_from_facebook_link
    link_to "Unlink from Facebook", confirm_facebook_unlinking_path, :class => 'connectacct-link facebook-auth disconnect-fb', :id => 'facebook-connect'
  end
  
  def link_with_facebook_link
    link_to("Connect with Facebook", person_omniauth_authorize_path(:facebook), :class => 'connectacct-link facebook-auth', :id => 'facebook-connect' )
  end
end