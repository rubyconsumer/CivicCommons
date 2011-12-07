module Facebookable
  FACEBOOK_AUTH_HASH = {
    'credentials' => {'token'=>"1234567890"}, 
    'provider' => "facebook",
    'uid' => "12345",
    'user_info' => { 'first_name' => 'John', 'last_name' => 'doe', 'name' => 'John Doe'},
    'extra' => { 'user_hash' => { 'email' => "johnd@test.com" } } 
  }
  def stub_facebook_auth
    OmniAuth.config.add_mock(:facebook, FACEBOOK_AUTH_HASH)
  end
end
