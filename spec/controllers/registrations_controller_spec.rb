require 'rails_helper'
require 'faker'
require 'sidekiq/testing'

describe RegistrationsController do
  describe 'PATCH #update' do

    let(:user) {
      create(:user)
    }

    let(:upload) {
      ActionDispatch::Http::UploadedFile.new(
        {
          filename: 'avatar.png',
          content_type: 'image/png',
          tempfile: File.new("#{Rails.root}/spec/support/images/small_image.png")
        }
      )
    }

    before(:each) {
      sign_in user
      request.env['devise.mapping'] = Devise.mappings[:user]
    }

    it 'uses no avatar if the \'none\' option is specified' do
      patch :update, user: {id: user.id, avatar_option: 'none'}
      resultant_user = User.find(user.id)
      expect(resultant_user.avatar_option).to eq 'none'
      expect(resultant_user.avatar.present?).to eq false
    end

    it 'uses an uploaded file in all other cases' do
      patch :update, user: {id: user.id, avatar_option: 'upload', avatar: upload}
      resultant_user = User.find(user.id)
      expect(resultant_user.avatar_option).to eq 'upload'
      expect(resultant_user.avatar.present?).to eq true
    end
  end

  describe 'POST #create' do

    let(:valid_sign_up_params) {
      {
        first_name: "James",
        last_name: "Bond",
        email: "bond@goldeneye.com",
        password: "0nh3rm4j357y'553cr3753rv1c3"
      }
    }

    let(:invalid_sign_up_params) {
      {
        first_name: "James",
        email: "bond@goldeneye",
      }
    }

    before(:each) do
      request.env['devise.mapping'] = Devise.mappings[:user]
      sign_out :user
    end

    it 'places the welcome email into the queue for a valid user' do
      expect do
        post :create, user: valid_sign_up_params
      end.to change(User, :count).by(1)
      expect(Sidekiq::Worker.jobs.size).to eq 1
    end

    it 'does not place the welcome email into the queue for an invalid user' do
      expect do
        post :create, user: invalid_sign_up_params
      end.not_to change(User, :count)
      expect(Sidekiq::Worker.jobs.size).to eq 0
    end
  end
end
