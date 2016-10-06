class AddColumnToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :comment_placeholder, :string
  end
end
