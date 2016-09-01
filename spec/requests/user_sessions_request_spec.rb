require 'rails_helper'
require 'support/omni_auth_test_helper'

describe "GET '/auth/facebook/callback'" do

  before(:each) do
    valid_facebook_login_setup
    get "/users/auth/facebook?role=Pre-Service%20Teacher"
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  it "should redirect user_omniauth_callback_path" do
    expect(response).to redirect_to user_omniauth_callback_path(:facebook)
  end

  it "should successfully create a new user" do
    expect { follow_redirect! }.to change(User, :count).by(1)
  end

  describe "follow redirect" do

    before(:each) do
      follow_redirect!
    end

    it "should redirect to root" do
      expect(response).to redirect_to root_path
    end

    it "should set the user's role to 'Pre-Service Teacher'" do
      expect(User.last.role).to eq('Pre-Service Teacher')
    end
  end
end
