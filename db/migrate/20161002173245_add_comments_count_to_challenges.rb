class AddCommentsCountToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :comments_count, :integer, nil: false, default: 0
  end
end
