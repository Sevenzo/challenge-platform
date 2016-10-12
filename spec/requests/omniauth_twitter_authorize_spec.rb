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
          image:      'https://pbs.twimg.com/profile_images/test_user_profile/erL8FDMo_normal.jpg',
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

  before(:each) do
    OmniAuth.config.mock_auth[oauth_strategy[:strategy]] = nil

    stub_request(:get, "https://pbs.twimg.com/profile_images/test_user_profile/erL8FDMo_400x400.jpg").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})
  end

  context 'with valid login infor for a new user' do
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
        first_name = info[:name].split(' ').first
        last_name = info[:name].split(' ').last
        expect(user.twitter).to eq info[:nickname]
        expect(user.first_name).to eq first_name
        expect(user.last_name).to eq last_name
        expect(user.location).to eq info[:location]
        expect(user.email).to eq email.downcase
        expect(user.avatar_option).to eq provider
        expect(user.avatar.url).to include info[:nickname]
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

    it 'redirects to callback' do
      expect(response).to redirect_to user_twitter_omniauth_callback_path
    end

    context 'redirect to callback' do
      before do
        follow_redirect!
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not create a new user' do
        # binding.pry
        expect_any_instance_of(User.class).not_to receive(:update_from_omniauth)
        expect { follow_redirect! }.not_to change(User, :count)
      end

      it 'displays the expected flash message' do
        expect(flash[:notice]).to match('Successfully signed in with Twitter!')
      end
    end
  end

  context 'with valid login info for an existing user with same email' do
    let!(:user) { create(:user, email: email) }
    before { omniauth_authenticate(valid_oauth_login) }

    it 'DOES NOT create a new user' do
      expect(response).to be_redirect
      expect { follow_redirect! }.not_to change(User, :count)
    end

    context 'following redirect' do
      before { follow_redirect! }

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'displays the expected flash message' do
        expect(flash[:notice]).to match('Successfully signed in with Twitter!')
      end

      it 'updates their profile with oauth credentials but not name' do
        user = User.last
        info = valid_oauth_login[:data][:info]
        expect(user.first_name).not_to eq info[:first_name]
        expect(user.last_name).not_to eq info[:last_name]
        expect(user.location).to eq info[:location]
        expect(user.avatar_option).to eq provider
        expect(user.avatar.url).to include info[:nickname]
      end
    end
  end

  context 'with valid login info for an existing user with same email/uid' do
    let!(:user) { create(:user, email: email) }
    let!(:identity) { create(:identity, uid: uid, user: user)}

    before { omniauth_authenticate(valid_oauth_login) }

    context 'following redirect' do
      before do
        follow_redirect!
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'displays the expected flash message' do
        expect(flash[:notice]).to match('Successfully signed in with Twitter!')
      end

      it 'does not create a new user' do
        expect{ follow_redirect! }.not_to change(User, :count)
      end
    end
  end

  context 'with invalid login info for a new user' do
    before { omniauth_authenticate(invalid_oauth_login) }

    it 'redirects to callback' do
      expect(response).to be_redirect
    end

    context 'following redirect' do
      before { follow_redirect! }

      it 'redirects to the failure callback' do
        expect(response).to redirect_to '/users/auth/failure?message=invalid_credentials&strategy=twitter'
      end
    end

    it 'does NOT create a new user' do
      expect { follow_redirect! }.not_to change(User, :count)
    end
  end

end
