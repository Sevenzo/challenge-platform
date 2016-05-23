require 'rails_helper'
require 'models/concerns/embeddable_concern'
require 'models/concerns/url_normalizer_concern'
require 'models/concerns/publishable_concern'
require 'models/concerns/feature_concern'
require 'models/concerns/default_ordering_concern'
require 'models/concerns/orderable_concern'
require 'models/concerns/likeable_concern'
require 'models/concerns/sortable_concern'

describe Experience do

  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_length_of(:description) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:theme) }
  it { is_expected.to have_one :feature }

  it { is_expected.to delegate_method(:experience_stage).to(:theme) }
  it { is_expected.to delegate_method(:challenge).to(:experience_stage) }

  it_behaves_like 'embeddable'
  it_behaves_like 'normalizable'
  it_behaves_like 'a publishable entity'
  it_behaves_like 'orderable'
  it_behaves_like 'likeable'
  it_behaves_like 'sortable'
  it_behaves_like 'an entity respecting the default order'

  let(:entity) {
    experience_stage = create(:experience_stage, challenge: challenge)
    theme = create(:theme, experience_stage: experience_stage)
    experience = create(:experience, theme: theme)

    experience
  }

  it_behaves_like 'a featurable entity'
end
