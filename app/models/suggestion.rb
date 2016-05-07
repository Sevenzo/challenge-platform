class Suggestion < ActiveRecord::Base
  include Embeddable
  include URLNormalizer
  default_scope { order(cached_votes_total: :desc, created_at: :desc, id: :desc) }

  belongs_to :user
  acts_as_votable
  acts_as_paranoid column: :destroyed_at

  validates :title,       presence: true
  validates :description, presence: true
  validates :link,        url: true, allow_blank: true

  RATING_WEIGHTS = [1, 2, 3, 4].freeze

  def icon
    'fa-archive'
  end

end
