module Facebookable
  FACEBOOK_AUTH_HASH = {
    'credentials' => {
      'token'=>"1234567890"
    },
    'provider' => "facebook",
    'uid' => "12345",
    'info' => {
      'email' => 'johnd@test.com',
      'first_name' => 'John',
      'last_name' => 'doe',
      'name' => 'John Doe'
    }
  }

  def auth_hash
    FACEBOOK_AUTH_HASH.clone
  end

  def stub_facebook_auth
    enact_stub auth_hash
  end

  def stub_facebook_auth_with_email_for user
    hash = auth_hash
    hash['info']['email'] = user.email
    enact_stub hash
  end
  def enact_stub hash
    OmniAuth.config.mock_auth.reject! { |k,v| k != :default }
    OmniAuth.config.add_mock(:facebook, hash)
  end
  def stub_facebook_auth_for user
    enact_stub({
      credentials: { token: user.facebook_authentication.token },
      provider: :facebook,
      uid: user.facebook_authentication.uid,
      info: {
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        name: user.name
      }
    })
  end
end
