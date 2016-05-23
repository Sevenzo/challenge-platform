require 'rails_helper'
require 'models/concerns/embeddable_concern'
require 'models/concerns/url_normalizer_concern'
require 'models/concerns/sortable_concern'

describe SolutionStory do

  it { is_expected.to belong_to(:solution_stage) }
  it { is_expected.to have_one(:solution) }
  it { is_expected.to delegate_method(:challenge).to(:solution_stage) }

  it_behaves_like 'embeddable'
  it_behaves_like 'normalizable'
  it_behaves_like 'sortable'

end
