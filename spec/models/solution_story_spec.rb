require 'rails_helper' 
require 'models/concerns/embeddable_concern'
require 'models/concerns/url_normalizer_concern'

describe SolutionStory do

  it { is_expected.to belong_to(:solution_stage) }
  it { is_expected.to have_one(:solution) }
  
  it_behaves_like 'embeddable'
  it_behaves_like 'normalizable'
end
