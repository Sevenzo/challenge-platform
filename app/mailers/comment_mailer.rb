class CommentMailer < ApplicationMailer
  default template_path: "mailers/#{mailer_name.split('_')[0].downcase}"

  def replied(comment_id, user_id)
    @comment =  Comment.find(comment_id)
    @resource = User.find(user_id)
    @subject = "#{@comment.user.display_name} replied to your comment on the #{@comment.commentable_type}: #{@comment.commentable_title.truncate(30)}"
  end

  def posted(comment_id, user_id)
    @comment =  Comment.find(comment_id)
    @resource = User.find(user_id)
    @subject = "#{@comment.user.display_name} commented on your #{@comment.commentable_type}: #{@comment.commentable_title.truncate(30)}"
  end

  def followed(comment_id, user_id)
    @comment =  Comment.find(comment_id)
    @resource = User.find(user_id)
    @subject = "#{@comment.user.display_name} added a comment in the discussion of #{@comment.commentable_type}: #{@comment.commentable_title.truncate(30)}"
  end

  def digest(comment_ids, user_id)
    @comments = comment_ids.transform_values { |ids| Comment.where(id: ids) if not ids.empty? }
    @resource = User.find(user_id)
    @subject = "#{@resource.digest_frequency.capitalize} digest email for #{@resource.display_name}."
  end

end
