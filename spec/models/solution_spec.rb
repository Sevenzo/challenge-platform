require 'rails_helper'
require 'models/concerns/embeddable_concern'
require 'models/concerns/url_normalizer_concern'
require 'models/concerns/publishable_concern'
require 'models/concerns/feature_concern'
require 'models/concerns/default_ordering_concern'
require 'models/concerns/orderable_concern'

describe Solution do

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:solution_story) }
  it { is_expected.to have_many(:steps) }
  it { is_expected.to have_and_belong_to_many(:experiences) }
  it { is_expected.to have_and_belong_to_many(:ideas) }
  it { is_expected.to have_and_belong_to_many(:recipes) }
  it { is_expected.to have_one :feature }

  it { is_expected.to delegate_method(:solution_stage).to(:solution_story) }
  it { is_expected.to delegate_method(:challenge).to(:solution_stage) }

  it_behaves_like 'embeddable'
  it_behaves_like 'normalizable'
  it_behaves_like 'a publishable entity'
  it_behaves_like 'orderable'
  it_behaves_like 'an entity respecting the default order'

  let(:entity) {
    solution_stage = create(:solution_stage, challenge: challenge)
    solution_story = create(:solution_story, solution_stage: solution_stage)
    solution = create(:solution, solution_story: solution_story)

    solution
  }

  it_behaves_like 'a featurable entity'
end
