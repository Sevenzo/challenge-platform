require 'rails_helper'

describe State do

  it { is_expected.to have_many(:districts) }
  it { is_expected.to have_and_belong_to_many(:users) }

end
