require 'rails_helper'

describe Theme do

  it { is_expected.to have_many(:experiences) }
  it { is_expected.to belong_to(:experience_stage) }

end
