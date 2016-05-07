require 'rails_helper'

describe ExperienceStage do

  it { is_expected.to belong_to(:challenge) }
  it { is_expected.to have_many(:themes) }
  it { is_expected.to have_many(:experiences).through(:themes) }

end  
