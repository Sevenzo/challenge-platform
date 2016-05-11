class Comment < ActiveRecord::Base
  include Embeddable
  include URLNormalizer
  include Likeable
  default_scope { order(created_at: :asc) }

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_one :feature, as: :featureable

  acts_as_votable
  acts_as_nested_set scope: [:commentable_id, :commentable_type]
  acts_as_paranoid column: :destroyed_at

  after_create do
    if temporal_parent_id.present?
      parent_comment = Comment.find_by(id: temporal_parent_id)
      move_to_child_of(parent_comment) if parent_comment
    end
  end

  validates :body, presence: true
  validates :link, url: true, allow_blank: true

  # We update our commentable both after we save our comment *and* after we destroy it.
  after_save do
    update_commentable_values
  end

  after_destroy do
    update_commentable_values
  end

  def send_notifications
    replied_notification_sent = false; posted_notification_sent = false

    ## PARENT COMMENT USER
    parent_comment_user = parent ? parent.user : nil
    if parent_comment_user && parent_comment_user != user && parent_comment_user.comment_replied.true?
      CommentMailer.delay.replied(id)
      replied_notification_sent = true
    end

    ## POSTING COMMENT USER
    commentable_user = commentable.user ? commentable.user : nil
    if commentable_user && commentable_user != user && commentable_user.comment_posted.true? &&
       (commentable_user == parent_comment_user ? !replied_notification_sent : true)
      CommentMailer.delay.posted(id)
      posted_notification_sent = true
    end

    ## SIBLING COMMENT USERS
    sibling_comments.collect(&:user).uniq.each do |sibling_comment_user|
      if sibling_comment_user != user && sibling_comment_user.comment_followed.true? &&
         (
          if sibling_comment_user == parent_comment_user
            !replied_notification_sent
          else
            sibling_comment_user == commentable_user ? !posted_notification_sent : true
          end
         )

        CommentMailer.delay.followed(id, sibling_comment_user.id)
      end
    end
  end

  def challenge
    commentable.challenge
  end

  # Helper class method that allows you to build a comment
  # by passing a commentable object, a user_id, and comment text
  # example in readme
  def self.build_from(obj, user_id, comment)
    new \
      commentable: obj,
      user_id: user_id,
      body: comment[:body],
      link: comment[:link]
  end

  # Helper method to check if a comment has children
  def has_children?
    children.any?
  end

  def has_parent?
    parent.present?
  end

  def sibling_comments
    commentable.comment_threads.where.not(id: id)
  end

  def commentable_title
    commentable.title.present? ? commentable.title : commentable.description.truncate(255)
  end

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  scope :find_comments_by_user, lambda { |user| where(user_id: user.id).order(created_at: :desc) }

  # Helper class method to look up all comments for
  # commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id| where(commentable_type: commentable_str.to_s, commentable_id: commentable_id).order(created_at: :desc) }

  # Helper class method to look up a commentable object
  # given the commentable class name and id
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end

private

  def update_commentable_values
    # These classes are the only ones that have the new comments_count column defined on them.
    # If you add a class to this array, be *certain* that there is a migration for the comments_count column.
    if COMMENTABLE_ENTITIES.include?(commentable.class.to_s)
      commentable.update_column(:comments_count, commentable.comment_threads.count)
    end
  end

end
