require 'rails_helper'
require 'support/omni_auth_test_helper'
require 'faker'
require 'sidekiq/testing'

describe "GET '/auth/facebook/callback'" do

  context 'with valid login info' do
    before(:each) do
      valid_facebook_login_setup
      facebook_authenticate
    end

    it "should create a new user" do
      expect(response).to be_redirect
      expect{ follow_redirect! }.to change(User, :count).by(1)
    end

    context "following redirect" do
      before(:each) do
        follow_redirect!
      end

      it "should redirect to root" do
        expect(response).to redirect_to edit_user_registration_path({setting: "onboard"})
      end
    end
  end

  context 'as an existing user' do
    let!(:user) do
      create(:user)
    end

    context 'whose email is associated with a Facebook user' do
      before(:each) do
        existing_user_facebook_login_setup
        facebook_authenticate
      end

      context 'who is not logged in' do

        it 'should not create a new user' do
          expect{ follow_redirect! }.not_to change(User, :count)
        end

        context 'follow redirect' do
          before(:each) do
            follow_redirect!
          end

          it 'should associate their account with facebook' do
            email = existing_user_facebook_login_setup["info"]["email"]
            provider = existing_user_facebook_login_setup["provider"]
            uid = existing_user_facebook_login_setup["uid"]

            follow_redirect!
            expect( User.find_by_email(email).uid ).to eq uid
            expect( User.find_by_email(email).provider ).to eq provider
          end
        end
      end

      context 'who is already logged in' do
        before(:each) do
          login_as(user, :scope => :user)
        end

        it 'should not create a new user' do
          follow_redirect!
          expect{ response }.not_to change(User, :count)
        end
      end
    end
  end
end


describe "GET '/auth/failure'" do

  before(:each) do
    invalid_facebook_login_setup
    facebook_authenticate
  end

  describe "follow redirect" do

    before(:each) do
      follow_redirect!
    end

    it "should redirect to the failure callback" do
      expect(response).to redirect_to '/users/auth/failure?message=invalid_credentials&strategy=facebook'
    end
  end
end
