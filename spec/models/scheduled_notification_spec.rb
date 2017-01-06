require 'rails_helper'

describe ScheduledNotification do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:comment) }

  let(:user) {
    create(:user, digest_frequency: digest_frequency, notifications: {
      comment_replied: true,
      comment_posted: true,
      comment_followed: true,
    })
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

  context 'for a user with with `digest_frequency` as `immediate` (default)' do
    let(:digest_frequency) { 'immediate' }

    context 'with replies' do
      it 'should not create any ScheduledNotification' do
        reply.send_notifications

        expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
        expect(user.scheduled_notifications).to be_empty
      end
    end

    context 'with posts' do
      it 'should not create a ScheduledNotification' do
        post.send_notifications

        expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
        expect(user.scheduled_notifications).to be_empty
      end
    end

    context 'with followed comments' do
      it 'should not create ScheduledNotifications' do
        comments.map(&:send_notifications)

        expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq comments.size
        expect(user.scheduled_notifications).to be_empty
      end
    end
  end

  context 'for a user with with `digest_frequency` as `daily`' do
    let(:digest_frequency) { 'daily' }

    context 'with replies' do
      it 'should create a ScheduledNotification' do
        reply.send_notifications

        expect(Sidekiq::Extensions::DelayedMailer.jobs).to be_empty
        expect(user.scheduled_notifications.size).to eq 1
        expect(user.scheduled_notifications).to all(be_replied)
      end
    end

    context 'with posts' do
      it 'should create a ScheduledNotification' do
        post.send_notifications

        expect(Sidekiq::Extensions::DelayedMailer.jobs).to be_empty
        expect(user.scheduled_notifications.size).to eq 1
        expect(user.scheduled_notifications).to all(be_posted)
      end
    end

    context 'with followed comments' do
      it 'should create as many ScheduledNotifications' do
        comments.map(&:send_notifications)

        expect(Sidekiq::Extensions::DelayedMailer.jobs).to be_empty
        expect(user.scheduled_notifications.size).to eq comments.size
        expect(user.scheduled_notifications).to all(be_followed)
      end
    end
  end

  context 'for a user with with `digest_frequency` as `weekly`' do
    let(:digest_frequency) { 'weekly' }

    context 'with replies' do
      it 'should create a ScheduledNotification' do
        reply.send_notifications

        expect(Sidekiq::Extensions::DelayedMailer.jobs).to be_empty
        expect(user.scheduled_notifications.size).to eq 1
        expect(user.scheduled_notifications).to all(be_replied)
      end
    end

    context 'with posts' do
      it 'should create a ScheduledNotification' do
        post.send_notifications

        expect(Sidekiq::Extensions::DelayedMailer.jobs).to be_empty
        expect(user.scheduled_notifications.size).to eq 1
        expect(user.scheduled_notifications).to all(be_posted)
      end
    end

    context 'with followed comments' do
      it 'should create as many ScheduledNotifications' do
        comments.map(&:send_notifications)

        expect(Sidekiq::Extensions::DelayedMailer.jobs).to be_empty
        expect(user.scheduled_notifications.size).to eq comments.size
        expect(user.scheduled_notifications).to all(be_followed)
      end
    end
  end
end
