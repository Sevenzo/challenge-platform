class Experience < ActiveRecord::Base
  include Embeddable
  include URLNormalizer
  include Publishable
  include Orderable

  belongs_to :user
  belongs_to :theme
  has_and_belongs_to_many :solutions
  has_one :feature, as: :featureable

  mount_uploader :file, FileUploader
  process_in_background :file

  acts_as_votable
  acts_as_commentable
  acts_as_paranoid column: :destroyed_at

  validates :description, presence: true
  validates :link,        url: true, allow_blank: true

  def title
    description.present? ? description.truncate(50) : nil
  end

  def experience_stage
    theme.experience_stage
  end

  def challenge
    experience_stage.challenge
  end

  def default_like
    DEFAULT_LIKE
  end

  def icon
    'fa-comment'
  end

end
