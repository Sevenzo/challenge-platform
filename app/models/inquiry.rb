class Inquiry < ActiveRecord::Base

  validates :email, presence: true
  validates :subject, presence: true
  validates :message, presence: true

end
