class AddIndexToIdentities < ActiveRecord::Migration
  def change
    add_index :identities, [:user_id, :provider], unique: true
    remove_index :identities, :user_id
  end
end
