class AddDataToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :data, :text
    add_index :identities, [:provider, :uid], unique: true
  end
end
