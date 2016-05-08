require 'rails_helper'

describe Cookbook do

  it { is_expected.to belong_to(:recipe_stage) }
  it { is_expected.to have_many(:recipes) }
  it { is_expected.to delegate_method(:challenge).to(:recipe_stage) }

end
