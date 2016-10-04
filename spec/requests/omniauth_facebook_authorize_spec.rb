require 'rails_helper'
require 'support/omniauth_helpers'
require 'pry'

RSpec.describe 'Facebook OAuth authorization', type: :request do

  let(:provider) { 'facebook' }
  let(:uid) { '12345' }
  let(:email) { 'TEST@EXAMPLE.COM' }

  let(:oauth_strategy) { { strategy: provider } }
  let(:valid_oauth_login) do
    oauth_strategy.merge(
      data: {
        provider: provider,
        uid: uid,
        info: {
          first_name: 'Gaius',
          last_name:  'Baltar',
          email:      email,
          location: 'Here, there'
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

      it 'sets the attributes on the user' do
        user = User.last
        info = valid_oauth_login[:data][:info]
        expect(user.first_name).to eq info[:first_name]
        expect(user.last_name).to eq info[:last_name]
        expect(user.location).to eq info[:location]
        expect(user.email).to eq email.downcase
        expect(user.avatar_option).to eq provider
        expect(user.avatar.url).to include uid
      end

      it 'redirects to complete profile path' do
        expect(response).to redirect_to edit_user_registration_path(setting: 'onboard')
      end
    end
  end

  context 'with valid login info for an existing user with same uid/provider' do
    let!(:user) { create(:user) }
    let!(:identity) { create(:identity, provider: provider, uid: uid, user: user)}

    before(:each) do
      omniauth_authenticate(valid_oauth_login)
    end

    it 'DOES NOT create a new user' do
      # => "/users/auth/facebook"
      flash
      binding.pry
      expect(response).to be_redirect
      expect { follow_redirect! }.not_to change(User, :count)
    end

    context 'redirect to callback' do
      before do
        follow_redirect!
        expect(response).to redirect_to root_path
        expect { follow_redirect! }.not_to change(User, :count)
      end

      it 'redirects to root path' do
        binding.pry
        expect(flash[:notice]).to match(/Already linked your #{provider} account!/)
      end
    end
  end

  # context 'with valid login info for an existing user with same email' do
  #   let!(:user) { create(:user, email: email) }
  #   before { omniauth_authenticate(valid_oauth_login) }

  #   it 'DOES NOT create a new user' do
  #     expect(response).to be_redirect
  #     expect { follow_redirect! }.not_to change(User, :count)
  #   end

  #   context 'following redirect' do
  #     before { follow_redirect! }

  #     it 'redirects to root path' do
  #       expect(response).to redirect_to root_path
  #     end

  #     it 'updates their profile with oauth credentials but not name' do
  #       user = User.last
  #       info = valid_oauth_login[:data][:info]
  #       expect(user.first_name).not_to eq info[:first_name]
  #       expect(user.last_name).not_to eq info[:last_name]
  #       expect(user.location).to eq info[:location]
  #       expect(user.avatar_option).to eq provider
  #       expect(user.avatar.url).to include uid
  #     end
  #   end
  # end

  # context 'with valid login info for an existing user with same email/uid' do
  #   let!(:user) { create(:user, email: email, uid: uid) }
  #   before { omniauth_authenticate(valid_oauth_login) }

  #   it 'DOES NOT create a new user' do
  #     expect(response).to be_redirect
  #     expect { follow_redirect! }.not_to change(User, :count)
  #   end

  #   context 'following redirect' do
  #     before do
  #       expect_any_instance_of(User).not_to receive(:update_from_omniauth)
  #       follow_redirect!
  #     end

  #     it 'redirects to root path' do
  #       expect(response).to redirect_to root_path
  #     end
  #   end
  # end

  # context 'with invalid login info for a new user' do
  #   before { omniauth_authenticate(invalid_oauth_login) }

  #   it 'does NOT create a new user' do
  #     expect(response).to be_redirect
  #     expect { follow_redirect! }.not_to change(User, :count)
  #   end

  #   context 'following redirect' do
  #     before { follow_redirect! }

  #     it 'redirects to the failure callback' do
  #       expect(response).to redirect_to '/users/auth/failure?message=invalid_credentials&strategy=facebook'
  #     end
  #   end
  # end

end
