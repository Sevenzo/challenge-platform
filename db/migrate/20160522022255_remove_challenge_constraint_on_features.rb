class RemoveChallengeConstraintOnFeatures < ActiveRecord::Migration
  def change
    change_column_null :features, :challenge_id, true
    remove_index :features, :challenge_id
  end
end
