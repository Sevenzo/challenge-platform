require 'rails_helper'
require 'models/concerns/embeddable_concern'
require 'models/concerns/url_normalizer_concern'
require 'models/concerns/feature_concern'
require 'models/concerns/publishable_concern'
require 'models/concerns/default_ordering_concern'
require 'models/concerns/orderable_concern'
require 'models/concerns/likeable_concern'

describe Recipe do

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }

  it { is_expected.to delegate_method(:recipe_stage).to(:cookbook) }
  it { is_expected.to delegate_method(:challenge).to(:recipe_stage) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:cookbook) }
  it { is_expected.to belong_to(:refinement_parent).class_name('Recipe') }
  it { is_expected.to have_many(:refinements).class_name('Recipe').with_foreign_key('refinement_parent_id') }
  it { is_expected.to have_many(:steps) }
  it { is_expected.to have_one :feature }

  it_behaves_like 'embeddable'
  it_behaves_like 'normalizable'
  it_behaves_like 'a publishable entity'
  it_behaves_like 'orderable'
  it_behaves_like 'likeable'
  it_behaves_like 'an entity respecting the default order'

  let(:entity) {
    recipe_stage = create(:recipe_stage, challenge: challenge)
    cookbook = create(:cookbook, recipe_stage: recipe_stage)
    recipe = create(:recipe, cookbook: cookbook)

    recipe
  }

  it_behaves_like 'a featurable entity'

end
