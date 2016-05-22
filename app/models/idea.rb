class Idea < ActiveRecord::Base
  include Embeddable
  include URLNormalizer
  include Publishable
  include Likeable
  default_scope { order(inspiration: :desc) }
  include Orderable
  include Sortable

  belongs_to :user
  belongs_to :problem_statement
  has_many :refinements, class_name: 'Idea', foreign_key: 'refinement_parent_id'
  belongs_to :refinement_parent, class_name: 'Idea'
  has_and_belongs_to_many :solutions
  has_one :feature, as: :featureable

  delegate :idea_stage, to: :problem_statement
  delegate :challenge, to: :idea_stage

  mount_uploader :file, FileUploader
  process_in_background :file

  acts_as_votable
  acts_as_commentable
  acts_as_paranoid column: :destroyed_at

  validates :title,       presence: true
  validates :description, rich_text_presence: true
  validates :link,        url: true, allow_blank: true

  def icon
    'fa-lightbulb-o'
  end

end
