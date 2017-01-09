class CommentMailerPreview < ActionMailer::Preview

  def replied
    comment = Comment.where('parent_id IS NOT NULL').first
    user = comment.parent.user
    CommentMailer.replied(comment.id, user.id)
  end

  def posted
    comment = Comment.first
    user =  comment.commentable.user
    CommentMailer.posted(coment.id, user.id)
  end

  def followed
    comment = Comment.first
    user =  User.first
    CommentMailer.followed(comment.id, user.id)
  end

  def digest_daily
    user = User.first
    user.update!(digest_frequency: 'daily')
    comment_ids = Notifications.scheduled_comments(user)
    CommentMailer.digest(comment_ids, user.id)
  end

  def digest_weekly
    user = User.first
    user.update!(digest_frequency: 'weekly')
    comment_ids = Notifications.scheduled_comments(user)
    CommentMailer.digest(comment_ids, user.id)
  end

end
