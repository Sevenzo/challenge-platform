require 'rails_helper'

describe Feature do

  let(:non_admin_user)  { create(:user) }
  let(:admin_user)  { create(:user, admin: true) }
  let(:feature) { create(:feature) }

  it { is_expected.to belong_to :featureable }
  it { is_expected.to belong_to :user }
end
