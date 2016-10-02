class AddGoalToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :goal, :string
  end
end
