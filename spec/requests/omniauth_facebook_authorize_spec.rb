require 'rails_helper'
require 'support/omniauth_helpers'

RSpec.describe 'Facebook OAuth authorization', type: :request do

  let(:oauth_strategy) { { strategy: 'facebook' } }
  let(:valid_oauth_login) do
    oauth_strategy.merge(
      data: {
        uid: '123545',
        info: {
          first_name: 'Gaius',
          last_name:  'Baltar',
          email:      'test@example.com'
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

  context 'with valid login info for a new user' do
    before { omniauth_authenticate(valid_oauth_login) }

    it 'creates a new user' do
      expect(response).to be_redirect
      expect { follow_redirect! }.to change(User, :count).by(1)
    end

    context 'following redirect' do
      before { follow_redirect! }

      it 'redirects to complete profile path' do
        expect(response).to redirect_to edit_user_registration_path(setting: 'onboard')
      end
    end
  end

  context 'with invalid login info for a new user' do
    before { omniauth_authenticate(invalid_oauth_login) }

    it 'does NOT create a new user' do
      expect(response).to be_redirect
      expect { follow_redirect! }.not_to change(User, :count)
    end

    context 'following redirect' do
      before { follow_redirect! }

      it 'redirects to the failure callback' do
        expect(response).to redirect_to '/users/auth/failure?message=invalid_credentials&strategy=facebook'
      end
    end
  end

end
