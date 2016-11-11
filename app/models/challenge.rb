class Challenge < ActiveRecord::Base
  extend FriendlyId
  include ActiveRecord::QueryMethods
  friendly_id :title, use: [:slugged, :finders]
  rails_admin do
    configure :slug do
      read_only true
    end
  end

  has_one :panel
  has_one :experience_stage
  has_one :idea_stage
  has_one :recipe_stage
  has_one :solution_stage

  mount_uploader :banner, ImageUploader
  process_in_background :banner

  acts_as_commentable

  def self.featured
    where(featured: true).where('starts_at < ?', Time.now).where('ends_at > ?', Time.now).first
  end

  def panelists
    panel.users
  end

  def featured_contributions
    case active_stage
    when 'experience'
      experience_stage.experiences.order_by('created_at DESC').published.first(2)
    when 'idea'
      idea_stage.ideas.published.where(inspiration: false).first(3)
    when 'recipe'
      recipe_stage.recipes.published.first(2)
    when 'solution'
      solution_stage.solutions.first(2)
    else
      []
    end
  end

  def has_featured_for(type)
    Feature.exists?(featureable_type: type, active: true, challenge_id: id)
  end

  def stage_number
    case active_stage
    when 'experience'
      1
    when 'idea'
      2
    when 'recipe'
      3
    when 'solution'
      4
    when 'done'
      5
    else
      0
    end
  end

  STAGES = [
    {
      number: 1,
      name: 'experience',
      alias: 'insight',
      action: 'shared',
      icon: 'fa-comments',
      headline: 'Share Insights',
      description: "Inspire, be inspired and gain insights before finding solutions."
    },
    {
      number: 2,
      name: 'idea',
      alias: 'bright spot',
      action: 'contributed',
      icon: 'fa-lightbulb-o',
      headline: 'Discover What Works',
      description: "Share new ideas or existing solutions that tackle challenges."
    },
    {
      number: 3,
      name: 'recipe',
      alias: 'recipe',
      action: 'developed',
      icon: 'fa-flask',
      headline: 'Develop Recipes',
      description: 'Co-design recipes offline to bring virtually shared ideas to life.'
    },
    {
      number: 4,
      name: 'solution',
      alias: 'implementation',
      action: 'shared',
      icon: 'fa-paper-plane-o',
      headline: 'Implement & Share',
      description: 'Lead or participate in implementation trials with like-minded peers.'
    }
  ]

end
