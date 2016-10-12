require 'rails_helper'
require 'support/omniauth_helpers'

RSpec.describe 'Twitter OAuth authorization', type: :request do

  let(:provider) { 'twitter' }
  let(:uid) { '12345' }
  let(:email) { 'TEST@EXAMPLE.COM' }

  let(:oauth_strategy) { { strategy: provider } }
  let(:valid_oauth_login) do
    oauth_strategy.merge(
      data: {
        provider: provider,
        uid: uid,
        info: {
          nickname:  'twitterhandle',
          name:      'Gaius Baltar',
          email:     email,
          location:  'San Francisco',
          image:      'https://pbs.twimg.com/profile_images/758137943970222080/erL8FDMo_normal.jpg',
          description: 'Oauth Twitter test robot. Here to serve humans.'
        },
        credentials: {
          token: '123456',
          expires_at: Time.now + 1.week
        },
        extra: {
          raw_info: {
            gender: 'male'
          }
        }
      }
    )
  end
  let(:invalid_oauth_login) do
    oauth_strategy.merge(data: { invalid_credentials: true })
  end

  before { OmniAuth.config.mock_auth[oauth_strategy[:strategy]] = nil }

  context 'with valid login infor for a new user' do
    before { omniauth_authenticate(valid_oauth_login) }

    it 'creates a new user' do
      expect(response).to be_redirect
      expect { follow_redirect! }.to change(User, :count).by(1)
    end
  end
end
