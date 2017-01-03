class CreateScheduledNotifications < ActiveRecord::Migration
  def change
    create_table :scheduled_notifications do |t|
      t.integer :notification_type, default: 0, index: true

      t.references :user, null: false, index: true
      t.references :comment, null: false, index: true

      t.timestamps null: false
    end

    add_index :scheduled_notifications, [:updated_at]
  end
end
