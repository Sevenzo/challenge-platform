class Comment < ActiveRecord::Base
  include Embeddable
  include URLNormalizer
  include Likeable

  default_scope { order(created_at: :asc) }
  scope :find_comments_by_user, -> (user) { where(user_id: user.id) }
  scope :find_comments_for_commentable, -> (type, id) { where(commentable_type: type.constantize, commentable_id: id) }

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_one :feature, as: :featureable
  has_many :scheduled_notifications, dependent: :destroy

  acts_as_votable
  acts_as_nested_set scope: [:commentable_id, :commentable_type]
  acts_as_paranoid column: :destroyed_at

  after_create do
    if temporal_parent_id.present?
      parent_comment = Comment.find_by(id: temporal_parent_id)
      move_to_child_of(parent_comment) if parent_comment
    end
  end

  after_save do
    update_commentable_values
  end

  after_destroy do
    update_commentable_values
  end

  validates :body, presence: true
  validates :link, url: true, allow_blank: true
  validates :commentable_type, :commentable_id, presence: true

  def self.build_from(obj, user_id, comment)
    new \
      commentable: obj,
      user_id: user_id,
      body: comment[:body],
      link: comment[:link]
  end

  def self.find_commentable(type, id)
    type.constantize.find(id)
  end

  def send_notifications
    return unless commentable.respond_to?(:user)

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

private

  def update_commentable_values
    commentable.update_column(:comments_count, commentable.comment_threads.count)
  rescue => e
    ExceptionNotifier.notify_exception(e)
  end

end
