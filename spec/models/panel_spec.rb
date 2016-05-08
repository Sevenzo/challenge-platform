require 'rails_helper'

describe Panel do

  it { is_expected.to belong_to(:challenge) }
  it { is_expected.to have_and_belong_to_many(:users) }

end
