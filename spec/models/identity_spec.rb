require 'rails_helper'

describe Identity do

  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:uid) }
  it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider) }
  it { is_expected.to validate_presence_of(:provider) }
  it { is_expected.to validate_uniqueness_of(:provider).scoped_to(:user_id) }

end
