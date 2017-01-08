require 'rails_helper'

describe ScheduledNotification do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:comment) }

end
