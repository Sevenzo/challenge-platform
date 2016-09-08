require 'rails_helper'
require 'support/omni_auth_test_helper'
require 'pry'

describe "GET '/auth/facebook/callback'" do

  before(:each) do
    valid_facebook_login_setup
    get "/users/auth/facebook"
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  it "should successfully create a new user" do
    expect { follow_redirect! }.to change(User, :count).by(1)
  end

  describe "follow redirect" do
    before(:each) do
      follow_redirect!
    end

    it "should redirect to root" do
      expect(response).to redirect_to edit_user_registration_path({setting: "onboard"})
    end
  end
end

describe "GET '/auth/failure'" do

  before(:each) do
    invalid_facebook_login_setup
    get "/users/auth/facebook"
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  describe "follow redirect" do

    before(:each) do
      follow_redirect!
    end
<<<<<<< HEAD
=======

    it "should redirect to the failure callback" do
      expect(response).to redirect_to '/users/auth/failure?message=invalid_credentials&strategy=facebook'
    end
>>>>>>> Update tests: Set env variables devise.mapping and omniauth.auth; Update requests specs (they'd broken during the PR #27 -> #29 transition).
  end
end
