require 'rails_helper'

RSpec.describe Inquiry, type: :model do

  # Validations
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:subject) }
  it { is_expected.to validate_presence_of(:message) }

end
