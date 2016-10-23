class Experience < ActiveRecord::Base
  include Embeddable
  include URLNormalizer
  include Publishable
  include Orderable
  include Likeable
  include Sortable

  belongs_to :user
  belongs_to :theme
  has_and_belongs_to_many :solutions
  has_one :feature, as: :featureable

  delegate :experience_stage, to: :theme
  delegate :challenge, to: :experience_stage

  mount_uploader :file, FileUploader
  process_in_background :file

  acts_as_votable
  acts_as_commentable
  acts_as_paranoid column: :destroyed_at

  validates :description, rich_text_presence: true
  validates :link,        url: true, allow_blank: true

  def title
    description.present? ?  ActionController::Base.helpers.strip_tags(description).truncate(30) : nil
  end

  def icon
    'fa-comments'
  end

end
