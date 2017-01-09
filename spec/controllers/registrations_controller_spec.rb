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

  describe 'POST #update' do
    let(:user) {
      create(:user, digest_frequency: digest_frequency, notifications: {
        comment_replied: true,
        comment_posted: true,
        comment_followed: true
      })
    }

    before(:each) {
      sign_in user
      request.env['devise.mapping'] = Devise.mappings[:user]
    }

    let(:commentable) {
      create(:experience)
    }

    let(:comment) {
      create(:comment, commentable: commentable, body: Faker::Lorem.paragraph, user: user)
    }

    let(:reply) {
      create(:comment, commentable: commentable, parent: comment, body: Faker::Lorem.paragraph, user: create(:user))
    }

    let(:post) {
      create(:comment, commentable: create(:experience, user: user), body: Faker::Lorem.paragraph, user: create(:user))
    }

    let(:comments) {
      comment # forces following

      10.times.map do
        create(:comment, commentable: commentable, body: Faker::Lorem.paragraph, user: create(:user, notifications: {
          comment_replied: false,
          comment_posted: false,
          comment_followed: false,
        }))
      end
    }

    context 'when a user has digest frequency as `immediately`' do
      let(:digest_frequency) { 'immediately' }

      context 'for replies pending' do
        it 'should do no flush' do
          reply.send_notifications

          expect(user.scheduled_notifications).to be_empty

          patch :update, user: {
            id: user.id,
            digest_frequency: 'immediately'
          }

          expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
          expect(user.scheduled_notifications).to be_empty

          updated_user = User.find user.id
          expect(updated_user.digest_frequency).to eq 'immediately'
        end
      end

      context 'for posts pending' do
        it 'should do no flush' do
          post.send_notifications

          expect(user.scheduled_notifications).to be_empty

          patch :update, user: {
            id: user.id,
            digest_frequency: 'immediately'
          }

          expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
          expect(user.scheduled_notifications).to be_empty

          updated_user = User.find user.id
          expect(updated_user.digest_frequency).to eq 'immediately'
        end
      end

      context 'for followed comments pending' do
        it 'should no flush' do
          comments.map(&:send_notifications)

          expect(user.scheduled_notifications).to be_empty

          patch :update, user: {
            id: user.id,
            digest_frequency: 'immediately'
          }

          expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq comments.size
          expect(user.scheduled_notifications).to be_empty

          updated_user = User.find user.id
          expect(updated_user.digest_frequency).to eq 'immediately'
        end
      end
    end

    context 'when a user switches between `daily` and `weekly` digest frequency' do
      context 'from `daily` to `weekly`' do
        let(:digest_frequency) { 'daily' }

        context 'for replies pending' do
          it 'should do no flush' do
            reply.send_notifications

            expect(user.scheduled_notifications.size).to eq 1

            patch :update, user: {
              id: user.id,
              digest_frequency: 'weekly'
            }

            expect(Sidekiq::Extensions::DelayedMailer.jobs).to be_empty
            expect(user.scheduled_notifications.size).to eq 1

            updated_user = User.find user.id
            expect(updated_user.digest_frequency).to eq 'weekly'
          end
        end

        context 'for posts pending' do
          it 'should do no flush' do
            post.send_notifications

            expect(user.scheduled_notifications.size).to eq 1

            patch :update, user: {
              id: user.id,
              digest_frequency: 'weekly'
            }

            expect(Sidekiq::Extensions::DelayedMailer.jobs).to be_empty
            expect(user.scheduled_notifications.size).to eq 1

            updated_user = User.find user.id
            expect(updated_user.digest_frequency).to eq 'weekly'
          end
        end

        context 'for followed comments pending' do
          it 'should no flush' do
            comments.map(&:send_notifications)

            expect(user.scheduled_notifications.size).to eq comments.size

            patch :update, user: {
              id: user.id,
              digest_frequency: 'weekly'
            }

            expect(Sidekiq::Extensions::DelayedMailer.jobs).to be_empty
            expect(user.scheduled_notifications.size).to eq comments.size

            updated_user = User.find user.id
            expect(updated_user.digest_frequency).to eq 'weekly'
          end
        end
      end

      context 'from `weekly` to `daily`' do
        let(:digest_frequency) { 'weekly' }

        context 'for replies pending' do
          it 'should do no flush' do
            reply.send_notifications

            expect(user.scheduled_notifications.size).to eq 1

            patch :update, user: {
              id: user.id,
              digest_frequency: 'daily'
            }

            expect(Sidekiq::Extensions::DelayedMailer.jobs).to be_empty
            expect(user.scheduled_notifications.size).to eq 1

            updated_user = User.find user.id
            expect(updated_user.digest_frequency).to eq 'daily'
          end
        end

        context 'for posts pending' do
          it 'should do no flush' do
            post.send_notifications

            expect(user.scheduled_notifications.size).to eq 1

            patch :update, user: {
              id: user.id,
              digest_frequency: 'daily'
            }

            expect(Sidekiq::Extensions::DelayedMailer.jobs).to be_empty
            expect(user.scheduled_notifications.size).to eq 1

            updated_user = User.find user.id
            expect(updated_user.digest_frequency).to eq 'daily'
          end
        end

        context 'for followed comments pending' do
          it 'should no flush' do
            comments.map(&:send_notifications)

            expect(user.scheduled_notifications.size).to eq comments.size

            patch :update, user: {
              id: user.id,
              digest_frequency: 'daily'
            }

            expect(Sidekiq::Extensions::DelayedMailer.jobs).to be_empty
            expect(user.scheduled_notifications.size).to eq comments.size

            updated_user = User.find user.id
            expect(updated_user.digest_frequency).to eq 'daily'
          end
        end
      end
    end

    context 'when a user changes digest frequency back to `immediately`' do
      context 'from `daily`' do
        let(:digest_frequency) { 'daily' }

        context 'for replies pending' do
          it 'should flush pending reply notifications' do
            reply.send_notifications

            expect(user.scheduled_notifications.size).to eq 1

            patch :update, user: {
              id: user.id,
              digest_frequency: 'immediately'
            }

            expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
            expect(user.scheduled_notifications).to be_empty

            updated_user = User.find user.id
            expect(updated_user.digest_frequency).to eq 'immediately'
          end
        end

        context 'for posts pending' do
          it 'should flush pending reply notifications' do
            post.send_notifications

            expect(user.scheduled_notifications.size).to eq 1

            patch :update, user: {
              id: user.id,
              digest_frequency: 'immediately'
            }

            expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
            expect(user.scheduled_notifications).to be_empty

            updated_user = User.find user.id
            expect(updated_user.digest_frequency).to eq 'immediately'
          end
        end

        context 'for followed comments pending' do
          it 'should flush pending followed notifications' do
            comments.map(&:send_notifications)

            expect(user.scheduled_notifications.size).to eq comments.size

            patch :update, user: {
              id: user.id,
              digest_frequency: 'immediately'
            }

            expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
            expect(user.scheduled_notifications).to be_empty

            updated_user = User.find user.id
            expect(updated_user.digest_frequency).to eq 'immediately'
          end
        end
      end

      context 'from `weekly`' do
        let(:digest_frequency) { 'daily' }

        context 'for replies pending' do
          it 'should flush pending reply notifications' do
            reply.send_notifications

            patch :update, user: {
              id: user.id,
              digest_frequency: 'immediately'
            }

            expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
            expect(user.scheduled_notifications).to be_empty

            updated_user = User.find user.id
            expect(updated_user.digest_frequency).to eq 'immediately'
          end
        end

        context 'for posts pending' do
          it 'should flush pending reply notifications' do
            post.send_notifications

            patch :update, user: {
              id: user.id,
              digest_frequency: 'immediately'
            }

            expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
            expect(user.scheduled_notifications).to be_empty

            updated_user = User.find user.id
            expect(updated_user.digest_frequency).to eq 'immediately'
          end
        end

        context 'for followed comments pending' do
          it 'should flush pending followed notifications' do
            comments.map(&:send_notifications)

            patch :update, user: {
              id: user.id,
              digest_frequency: 'immediately'
            }

            expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
            expect(user.scheduled_notifications).to be_empty

            updated_user = User.find user.id
            expect(updated_user.digest_frequency).to eq 'immediately'
          end
        end
      end
    end
  end
end
