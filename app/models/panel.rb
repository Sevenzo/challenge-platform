class Panel < ActiveRecord::Base
  belongs_to :challenge
  has_and_belongs_to_many :users 
  
end
