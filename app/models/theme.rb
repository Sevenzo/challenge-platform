class Theme < ActiveRecord::Base
  belongs_to :experience_stage
  has_many :experiences 

end
