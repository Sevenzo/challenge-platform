class CommentMailerPreview < ActionMailer::Preview

  def replied
    comment = Comment.where('parent_id IS NOT NULL').first
    CommentMailer.replied(comment.id, comment.parent.user.id)
  end

  def posted
    comment = Comment.first
    CommentMailer.posted(coment.id, comment.commentable.user.id)
  end

  def followed
    CommentMailer.followed(Comment.first.id, User.first.id)
  end

  def digest_daily
    user = User.daily.first

    comment_ids = Notifications.scheduled_comments(user)

    CommentMailer.digest(comment_ids, user.id)
  end

  def digest_weekly
    user = User.weekly.first

    comment_ids = Notifications.scheduled_comments(user)

    CommentMailer.digest(comment_ids, user.id)
  end

end
