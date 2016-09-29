class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  ## Rails Admin
  rails_admin do
    configure :password do
      read_only true
    end
    configure :password_confirmation do
      read_only true
    end
  end

  has_and_belongs_to_many :states
  has_and_belongs_to_many :districts
  has_and_belongs_to_many :schools
  has_and_belongs_to_many :panels
  has_many :experiences
  has_many :ideas
  has_many :recipes
  has_many :solutions
  has_many :comments
  has_many :suggestions
  has_many :identities
  belongs_to :referrer, class_name: 'User', foreign_key: :referrer_id
  has_many :referrals,  class_name: 'User', foreign_key: :referrer_id
  store_accessor :notifications, :comment_replied, :comment_posted, :comment_followed

  mount_uploader :avatar, AvatarUploader
  process_in_background :avatar unless Rails.env.development?

  acts_as_voter
  mailkick_user

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  before_create do |user|
    user.color = User::COLORS.sample
    user.display_name = "#{user.first_name} #{user.last_name[0]}"
  end

  before_save do |user|
    user.email = user.email.downcase
    user.twitter = user.twitter.sub('@','') if user.twitter.present?
  end

  MAX_AVATAR_SIZE = 3

  ## VALIDATIONS
  validates :first_name,    presence: true, length: { maximum: 255 }
  validates :last_name,     presence: true, length: { maximum: 255 }
  validates :display_name,  presence: true, length: { maximum: 255 }, on: :update
  validates :role,          presence: true, length: { maximum: 255 }, on: :update
  validates :organization,  length: { maximum: 255 }, allow_blank: true
  validates :title,         length: { maximum: 255 }, allow_blank: true
  validates :twitter,       length: { maximum: 16 },  allow_blank: true
  validates :twitter,       presence: true, if: "avatar_option == 'twitter'"
  validates :uid,           uniqueness: { scope: :provider }, if: "provider.present?"
  validate  :avatar_file_size

  def name
    "#{first_name} #{last_name}"
  end

  def display_organization
    if organization.present?
      organization
    elsif schools.present?
      schools.first.name
    elsif districts.present?
      districts.first.name
    elsif states.present?
      states.first.name
    else
      ''
    end
  end

  def initials
    "#{first_name[0]}#{last_name[0]}"
  end

  def habtm_organizations?
    states.present? || districts.present? || schools.present?
  end

  def profile_complete?
    role.present? ||
    organization.present? ||
    title.present? ||
    twitter.present? ||
    habtm_organizations?
  end

  def states_json
    states.to_json(only: [:id, :name, :mail_state])
  end

  def districts_json
    districts.to_json(only: [:id, :name, :location_city, :location_state])
  end

  def schools_json
    schools.to_json(only: [:id, :name, :location_city, :location_state])
  end

  def is_school_role?
    ['Student', 'Current Teacher', 'Teacher Leader', 'Instructional Coach', 'School Leader'].include?(role)
  end

  def is_on_panel?(challenge)
    panels.exists?(challenge_id: challenge.id)
  end

  def has_draft_submissions?
    experiences.exists?(['published_at IS NULL']) || ideas.exists?(['published_at IS NULL']) || recipes.exists?(['published_at IS NULL']) || solutions.exists?(['published_at IS NULL'])
  end

  def set_avatar_from_twitter
    best_avatar_url = nil

    if twitter.present? && avatar_option == 'twitter'
      begin
        twitter_rest_client = Twitter::REST::Client.new(TWITTER_CONFIG)
        twitter_user_object = twitter_rest_client.user(twitter)
        best_avatar_url = twitter_user_object.profile_image_url_https.to_s.sub('_normal', '_400x400')
      rescue Twitter::Error::NotFound
        twitter = nil
      rescue
        best_avatar_url = "https://avatars.io/twitter/#{twitter}/large"
      end
    end

    self.remote_avatar_url = best_avatar_url
    self.save!
  rescue
  end

  def set_avatar_from_facebook
    best_avatar_url = nil

    if facebook.present? && avatar_option == 'facebook'
      begin
        best_avatar_url = "https://graph.facebook.com/v2.6/#{facebook}/picture?width=400&height=400"
      rescue
        best_avatar_url = "https://avatars.io/facebook/#{facebook}/large"
      end
    end

    self.remote_avatar_url = best_avatar_url
    self.save!
  rescue
  end

  def facebook
    uid
  end

  # Create a new User with the information that is available after OmniAuth authentication
  def self.create_from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.email = auth.info.email.downcase
      user.location = auth.info.location
      user.password = Devise.friendly_token[0, 20]
      user.avatar_option = auth.provider
      user.remote_avatar_url = auth.info.image
    end
  end

  # Update an existing User usting the information that is available after OmniAuth authentication
  def update_from_omniauth(auth)
    self.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.location = auth.info.location unless user.location.present?
      user.avatar_option = auth.provider
      user.remote_avatar_url = auth.info.image
    end
    self.save!
  end

  # <p class='select-help'>I am currently training to be a teacher in a whole class, resource, or one-on-one setting.</p>
  # <p class='select-help'>I am currently working with a whole class in a classroom, in small groups in a resource room, or one-on-one inside or outside a regular classroom.</p>
  # <p class='select-help'>I am currently a teacher and I spend a portion of my time supporting other adults in my school.</p>
  # <p class='select-help'>I spend the majority of my time supporting the professional development of adults in my school.</p>
  # <p class='select-help'>I am an administrator in a school (principal, assistant principal, dean, etc.).</p>

  ROLES = {
    'Student' => 'Student',
    'Pre-Service Teacher' => 'Pre-Service Teacher',
    'Current Teacher' => 'Current Teacher',
    'Teacher Leader' => 'Teacher Leader',
    'Instructional Coach' => 'Instructional Coach',
    'School Leader' => 'School Leader',
    'District or CMO Staff' => 'LEA Staff',
    'State Educational Agency Staff' => 'SEA Staff',
    'Other' => 'Other'
  }.freeze

  COLORS = %w(#11487e #8BB734 #7F3F98 #F26606).freeze

private

  def avatar_file_size
    if avatar && avatar.file && avatar.file.size.to_i > MAX_AVATAR_SIZE.megabytes.to_i
      errors.add(:avatar, "Avatar is too large; it must be smaller than #{MAX_AVATAR_SIZE} MB")
    end
  end

end
