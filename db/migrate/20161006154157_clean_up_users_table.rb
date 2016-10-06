class CleanUpUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :avatar_processing, :boolean, null: false, default: false
    remove_column :users, :ga_dimension
    remove_column :users, :video_access
    remove_column :users, :future_participant
  end
end
