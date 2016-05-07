require 'rails_helper'

describe ProblemStatement do

  it { is_expected.to belong_to(:idea_stage) }
  it { is_expected.to have_many(:ideas) }

end
