class Solution < ActiveRecord::Base
  include Embeddable
  include URLNormalizer
  include Publishable
  include Orderable
  include Likeable

  belongs_to :solution_story
  belongs_to :user
  has_many :steps, as: :steppable
  has_one :feature, as: :featureable
  has_and_belongs_to_many :experiences
  has_and_belongs_to_many :ideas
  has_and_belongs_to_many :recipes

  delegate :solution_stage, to: :solution_story
  delegate :challenge, to: :solution_stage

  mount_uploader :file, FileUploader
  process_in_background :file

  acts_as_votable
  acts_as_commentable
  acts_as_paranoid column: :destroyed_at

  def icon
    'fa-puzzle-piece'
  end

end
