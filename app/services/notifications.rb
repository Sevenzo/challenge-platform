module Notifications

  def self.digest(frequency = nil)
    case frequency
    when :daily
      users = User.daily.includes(:scheduled_notifications)
    when :weekly
      users = User.weekly.includes(:scheduled_notifications)
    else
      users = []
    end

    return if users.empty?

    users.each { |user| flush(user) }
  end

  def self.scheduled_comments(user)
    comments = {}

    if user.comment_replied.true?
      comments[:replied] = user.scheduled_notifications.replied.pluck(:comment_id)
    end

    if user.comment_posted.true?
      comments[:posted] = user.scheduled_notifications.posted.pluck(:comment_id)
    end

    if user.comment_followed.true?
      comments[:followed] = user.scheduled_notifications.followed.pluck(:comment_id)
    end

    comments
  end

  def self.flush(user)
    return if user.scheduled_notifications.empty?

    CommentMailer.delay.digest(scheduled_comments(user), user.id) unless Rails.env.development?

    user.scheduled_notifications.destroy_all
  end

end
