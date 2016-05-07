class School < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :district

  def self.search(search)
    limit(5).where('LOWER(name) LIKE ?', "%#{search.downcase}%") if search != ''
  end
  
end
