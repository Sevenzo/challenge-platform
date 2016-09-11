module OmniauthHelpers

  def omniauth_authenticate(mock_login)
    strategy = mock_login[:strategy].to_sym

    set_mock_auth(strategy, mock_login[:data])
    get user_omniauth_authorize_path(strategy)

    request.env['devise.mapping'] = Devise.mappings[:user]
    request.env['omniauth.env'] = OmniAuth.config.mock_auth[strategy]
  end

  def set_mock_auth(strategy, omniauth_hash)
    if omniauth_hash.keys.include?(:invalid_credentials)
      OmniAuth.config.mock_auth[strategy] = :invalid_credentials
    else
      OmniAuth.config.add_mock(strategy, omniauth_hash)
    end
  end

end

OmniAuth.config.test_mode = true
OmniAuth.config.on_failure = proc { |env| OmniAuth::FailureEndpoint.new(env).redirect_to_failure }

RSpec.configure do |config|
  config.include OmniauthHelpers, type: :request
end
