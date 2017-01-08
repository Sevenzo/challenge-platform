class ScheduledNotification < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment

  enum notification_type: [:replied, :posted, :followed]
end
