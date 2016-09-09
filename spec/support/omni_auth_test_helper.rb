module OmniAuthTestHelper
  def facebook_authenticate_and_redirect
    get_via_redirect "/users/auth/facebook"
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  def facebook_authenticate
    get "/users/auth/facebook"
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  def valid_facebook_login_setup
    if Rails.env.test?
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        provider: 'facebook',
        uid: '123545',
        info: {
          first_name: "Gaius",
          last_name:  "Baltar",
          email:      "test@example.com"
        },
        credentials: {
          token: "123456",
          expires_at: Time.now + 1.week
        },
        extra: {
          raw_info: {
            gender: 'male'
          }
        }
      })
    end
  end

  def invalid_facebook_login_setup
    if Rails.env.test?
      OmniAuth.config.test_mode = true
      OmniAuth.config.on_failure = Proc.new { |env|
        OmniAuth::FailureEndpoint.new(env).redirect_to_failure
      }
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    end
  end

  def existing_user_facebook_login_setup
    if Rails.env.test?
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        provider: 'facebook',
        uid: '123545',
        info: {
          first_name: "Jaakko",
          last_name:  "Kalevi",
          email:      "testname1@example.com"
        },
        credentials: {
          token: "123456",
          expires_at: Time.now + 1.week
        },
        extra: {
          raw_info: {
            gender: 'male'
          }
        }
      })
    end
  end
end

RSpec.configure do |config|
  config.include OmniAuthTestHelper, type: :request
  config.include Warden::Test::Helpers, type: :request
end
