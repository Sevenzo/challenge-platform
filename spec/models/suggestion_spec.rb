require 'rails_helper'
require 'models/concerns/embeddable_concern'
require 'models/concerns/url_normalizer_concern'

describe Suggestion do

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }  
  # it { is_expected.to validate_length_of(:description).is_at_most(1024)}
  it { is_expected.to belong_to(:user) }

  it_behaves_like 'embeddable'
  it_behaves_like 'normalizable'
end
