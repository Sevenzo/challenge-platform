require 'rails_helper'

describe Notifications do
  let(:reply) {
    experience = create(:experience, user: user)
    comment = create(:comment, commentable: experience, body: Faker::Lorem.paragraph, user: user)

    create(:comment, commentable: experience, parent: comment, body: Faker::Lorem.paragraph, user: create(:user))
  }

  let(:post) {
    experience = create(:experience, user: user)

    create(:comment, commentable: experience, body: Faker::Lorem.paragraph, user: create(:user, notifications: {
      :comment_replied => false,
      :comment_posted => false,
      :comment_followed => false
    }))
  }

  let(:comments) {
    experience = create(:experience, user: user)

    create(:comment, commentable: experience, body: Faker::Lorem.paragraph, user: user)

    10.times.map do
      create(:comment, commentable: experience, body: Faker::Lorem.paragraph, user: create(:user, notifications: {
        :comment_replied => false,
        :comment_posted => false,
        :comment_followed => false
      }))
    end
  }

  let(:user) {
    create(:user, digest_frequency: digest_frequency, notifications: notifications)
  }

  let(:notifications) {
    { comment_replied: true, comment_posted: true, comment_followed: true }
  }

  describe '#digest' do
    describe 'wrong arguments provided' do
      context 'when no frequency is provided' do
        let(:digest_frequency) { 'daily' }

        it 'should do nothing' do
          reply.send_notifications
          expect(user.scheduled_notifications.size).to eq 1
          Notifications.digest

          expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 0
          expect(user.scheduled_notifications.size).to eq 1
        end
      end

      context 'when a bad frequency is provided' do
        let(:digest_frequency) { 'daily' }

        it 'should do nothing' do
          reply.send_notifications
          expect(user.scheduled_notifications.size).to eq 1
          Notifications.digest :bananas

          expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 0
          expect(user.scheduled_notifications.size).to eq 1
        end
      end
    end

    describe '#daily' do
      context 'when no users are found' do
        let(:digest_frequency) { 'immediate' }

        it 'should do nothing' do
          reply.send_notifications
          expect(user.scheduled_notifications.size).to eq 0
          Notifications.digest :daily

          # user has immediate `digest_frequency` so it should queue the message
          expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
          expect(user.scheduled_notifications.size).to eq 0
        end
      end

      context 'when no scheduled_notifications are found' do
        let(:digest_frequency) { 'daily' }
        let(:notifications) { { comment_replied: false, comment_posted: false, comment_followed: false } }

        it 'should do nothing' do
          reply.send_notifications
          expect(user.scheduled_notifications.size).to eq 0
          Notifications.digest :daily
          expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 0
          expect(user.scheduled_notifications.size).to eq 0
        end
      end

      context 'for a user with `digest_frequency` as `daily` replying to a comment' do
        let(:digest_frequency) { 'daily' }

        it 'should queue a notification' do
          reply.send_notifications
          expect(user.scheduled_notifications.size).to eq 1
          Notifications.digest :daily
          expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
          expect(user.scheduled_notifications.size).to eq 0
        end
      end

      context 'for a user with `digest_frequency` as `daily` posting to a comment' do
        let(:digest_frequency) { 'daily' }

        it 'should queue a notification' do
          post.send_notifications
          expect(user.scheduled_notifications.size).to eq 1
          Notifications.digest :daily
          expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
          expect(user.scheduled_notifications.size).to eq 0
        end
      end

      context 'for a user with `digest_frequency` as `daily` following posts to a comment' do
        let(:digest_frequency) { 'daily' }

        it 'should queue a notification' do
          comments.map(&:send_notifications)
          expect(user.scheduled_notifications.size).to eq 10
          Notifications.digest :daily

          # only one email is queued: the digest email
          expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
          expect(user.scheduled_notifications.size).to eq 0
        end
      end
    end

    describe '#weekly' do
      context 'when no users are found' do
        let(:digest_frequency) { 'immediate' }

        it 'should do nothing' do
          reply.send_notifications
          expect(user.scheduled_notifications.size).to eq 0
          Notifications.digest :weekly

          # user has immediate `digest_frequency` so it should queue the message
          expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
          expect(user.scheduled_notifications.size).to eq 0
        end
      end

      context 'when no scheduled_notifications are found' do
        let(:digest_frequency) { 'weekly' }
        let(:notifications) { { comment_replied: false, comment_posted: false, comment_followed: false } }

        it 'should do nothing' do
          reply.send_notifications
          expect(user.scheduled_notifications.size).to eq 0
          Notifications.digest :weekly
          expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 0
          expect(user.scheduled_notifications.size).to eq 0
        end
      end

      context 'for a user with `digest_frequency` as `weekly` replying to a comment' do
        let(:digest_frequency) { 'weekly' }

        it 'should queue a notification' do
          reply.send_notifications
          expect(user.scheduled_notifications.size).to eq 1
          Notifications.digest :weekly
          expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
          expect(user.scheduled_notifications.size).to eq 0
        end
      end

      context 'for a user with `digest_frequency` as `weekly` posting to a comment' do
        let(:digest_frequency) { 'weekly' }

        it 'should queue a notification' do
          post.send_notifications
          expect(user.scheduled_notifications.size).to eq 1
          Notifications.digest :weekly
          expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
          expect(user.scheduled_notifications.size).to eq 0
        end
      end

      context 'for a user with `digest_frequency` as `weekly` following posts to a comment' do
        let(:digest_frequency) { 'weekly' }

        it 'should queue a notification' do
          comments.map(&:send_notifications)
          expect(user.scheduled_notifications.size).to eq 10
          Notifications.digest :weekly

          # only one email is queued: the digest email
          expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
          expect(user.scheduled_notifications.size).to eq 0
        end
      end
    end
  end
end
