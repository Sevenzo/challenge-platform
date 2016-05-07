require 'rails_helper' 

describe SolutionStage do

  it { is_expected.to belong_to(:challenge) }
  it { is_expected.to have_many(:solution_stories) }
  it { is_expected.to have_many(:solutions).through(:solution_stories) }

end
