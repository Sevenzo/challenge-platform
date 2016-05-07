require 'rails_helper'

describe District do

  it { is_expected.to belong_to(:state) }
  it { is_expected.to have_many(:schools) }
  it { is_expected.to have_and_belong_to_many(:users) }

end
