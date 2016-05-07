class District < ActiveRecord::Base
  belongs_to :state
  has_and_belongs_to_many :users
  has_many :schools

  def self.search(search)
    limit(5).where('LOWER(name) LIKE ?', "%#{search.downcase}%") if search != ''
  end

end
