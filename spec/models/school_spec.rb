require 'rails_helper'

describe School do

  it { is_expected.to belong_to(:district) }
  it { is_expected.to have_and_belong_to_many(:users) }

end
