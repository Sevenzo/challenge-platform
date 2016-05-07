require 'rails_helper'

describe IdeaStage do

  it { is_expected.to belong_to(:challenge) }
  it { is_expected.to have_many(:problem_statements) }
  it { is_expected.to have_many(:ideas).through(:problem_statements) }

end
