class Recipe < ActiveRecord::Base
  include Embeddable
  include URLNormalizer
  include Publishable
  include Orderable

  belongs_to :cookbook
  belongs_to :user
  has_many :steps, as: :steppable
  has_one :feature, as: :featureable
  has_many :refinements, class_name: 'Recipe', foreign_key: 'refinement_parent_id'
  belongs_to :refinement_parent, class_name: 'Recipe'
  has_and_belongs_to_many :solutions

  accepts_nested_attributes_for :steps, allow_destroy: true, reject_if: lambda { |step| step['description'].blank? }

  delegate :recipe_stage, to: :cookbook
  delegate :challenge, to: :recipe_stage

  mount_uploader :file, FileUploader
  process_in_background :file

  acts_as_votable
  acts_as_commentable
  acts_as_paranoid column: :destroyed_at

  validates :title,       presence: true
  validates :description, rich_text_presence: true
  validates :link,        url: true, allow_blank: true

  def default_like
    DEFAULT_LIKE
  end

  def icon
    'fa-flask'
  end

end
