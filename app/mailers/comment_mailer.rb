class CommentMailer < ApplicationMailer
  default template_path: "mailers/#{mailer_name.split('_')[0].downcase}"

  def replied(comment_id, user_id)
    @comment =  Comment.find(comment_id)
    @resource = User.find(user_id)
    @subject = "#{ENV.fetch('COMPANY_NAME')}: #{@comment.user.display_name} replied to your comment on #{@comment.commentable_title.truncate(30)}"
  end

  def posted(comment_id, user_id)
    @comment =  Comment.find(comment_id)
    @resource = User.find(user_id)
    @subject = "#{ENV.fetch('COMPANY_NAME')}: #{@comment.user.display_name} commented on #{@comment.commentable_title.truncate(30)}"
  end

  def followed(comment_id, user_id)
    @comment =  Comment.find(comment_id)
    @resource = User.find(user_id)
    @subject = "#{ENV.fetch('COMPANY_NAME')}: #{@comment.user.display_name} added a comment in the discussion of #{@comment.commentable_title.truncate(30)}"
  end

  def digest(comment_ids, user_id)
    @comments = comment_ids.transform_values { |ids| Comment.where(id: ids) unless ids.empty? }
    @resource = User.find(user_id)
    @subject = "#{ENV.fetch('COMPANY_NAME')}: #{@resource.digest_frequency.titleize} Activity Digest for #{@resource.display_name}"
  end

end
