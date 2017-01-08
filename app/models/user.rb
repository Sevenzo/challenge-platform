class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:twitter, :facebook]

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
  has_many :identities, dependent: :destroy
  belongs_to :referrer, class_name: 'User', foreign_key: :referrer_id
  has_many :referrals,  class_name: 'User', foreign_key: :referrer_id
  store_accessor :notifications, :comment_replied, :comment_posted, :comment_followed

  mount_uploader :avatar, AvatarUploader
  process_in_background :avatar unless Rails.env.development?

  # Enumerating options for scheduled digest emails
  enum digest_frequency: [ :immediately, :daily, :weekly ]

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
  validates :organization,  presence: true, length: { maximum: 255 }, on: :update
  validates :title,         length: { maximum: 255 }, allow_blank: true
  validates :twitter,       length: { maximum: 16 },  allow_blank: true
  validate  :avatar_file_size

  def name
    "#{first_name} #{last_name}"
  end

  def display_organization
    organization.to_s.truncate(50)
  end

  def initials
    "#{first_name[0]}#{last_name[0]}"
  end

  def profile_complete?
    role.present? && organization.present?
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

  def has_draft_submissions?
    experiences.exists?(['published_at IS NULL']) ||
    ideas.exists?(['published_at IS NULL']) ||
    recipes.exists?(['published_at IS NULL']) ||
    solutions.exists?(['published_at IS NULL'])
  end

  ## Twitter Oauth Methods
  def self.create_from_twitter(auth)
    create do |user|
      user.first_name = auth.info.name.split(' ').first
      user.last_name = auth.info.name.split(' ').last
      user.email = auth.info.email.downcase
      user.location = auth.info.location
      user.password = Devise.friendly_token[0, 20]
      user.avatar_option = auth.provider
      user.remote_avatar_url = auth.info.image.sub('_normal', '_400x400')
      user.twitter = auth.info.nickname
    end
  end

  def update_from_twitter(auth)
    self.tap do |user|
      user.location = auth.info.location unless user.location.present?
      user.avatar_option = auth.provider
      user.remote_avatar_url = auth.info.image.sub('_normal', '_400x400')
      user.twitter = auth.info.nickname
    end
    self.save!(validate: false)
  end

  def twitter_identity
    identities.find_by(provider: 'twitter')
  end

  def set_avatar_from_twitter
    best_avatar_url = nil

    if twitter_identity && (twitter.blank? || twitter == twitter_identity.data.info.nickname)
      best_avatar_url = twitter_identity.best_avatar_url
    elsif twitter.present?
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

    self.avatar_option = 'upload' unless best_avatar_url
    self.remote_avatar_url = best_avatar_url
    self.save!(validate: false)
  rescue
  end

  ## Facebook Oauth Methods
  def self.create_from_facebook(auth)
    create do |user|
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.email = auth.info.email.downcase
      user.location = auth.info.location
      user.password = Devise.friendly_token[0, 20]
      user.avatar_option = auth.provider
      user.remote_avatar_url = auth.info.image
    end
  end

  def update_from_facebook(auth)
    self.tap do |user|
      user.location = auth.info.location unless user.location.present?
      user.avatar_option = auth.provider
      user.remote_avatar_url = auth.info.image
    end
    self.save!(validate: false)
  end

  def facebook_identity
    identities.find_by(provider: 'facebook')
  end

  def set_avatar_from_facebook
    best_avatar_url = facebook_identity ? facebook_identity.best_avatar_url : nil

    self.avatar_option = 'upload' unless best_avatar_url
    self.remote_avatar_url = best_avatar_url
    self.save!(validate: false)
  rescue
  end

  ##
  # gets the defaults for email digest frequency
  #
  def self.digest_options
    digest_frequencies.keys
  end

  def digest_frequency_unit
    case true
    when daily?
      'day'
    when weekly?
      'week'
    end
  end

  def traits
    {
      id: id,
      email: email,
      firstName: first_name,
      lastName: last_name,
      organization: organization,
      role: role,
      title: title,
      description: bio,
      twitter: twitter,
      avatar: avatar.url,
      location: location,
      createdAt: created_at,
      updatedAt: updated_at,
      signInCount: sign_in_count,
      currentSignInAt: current_sign_in_at,
      lastSignInAt: last_sign_in_at,
      currentSignInIP: current_sign_in_ip,
      lastSignInIP: last_sign_in_ip
    }
  end

  ROLES = {
    'Pre-Service Teacher' => 'Pre-Service Teacher',
    'Current Teacher' => 'Current Teacher',
    'Teacher Leader' => 'Teacher Leader',
    'Instructional Coach' => 'Instructional Coach',
    'School Administrator' => 'School Administrator',
    'School Support Staff' => 'School Support Staff',
    'District or CMO Staff' => 'LEA Staff',
    'State Educational Agency Staff' => 'SEA Staff',
    'Student' => 'Student',
    'Parent' => 'Parent',
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
