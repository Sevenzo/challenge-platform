class SolutionStory < ActiveRecord::Base
  include Embeddable
  include URLNormalizer
  default_scope { order(created_at: :asc) }

  belongs_to :solution_stage
  has_one :solution

  delegate :challenge, to: :solution_stage

  acts_as_paranoid column: :destroyed_at

  mount_uploader :image, ImageUploader
  process_in_background :image

end
