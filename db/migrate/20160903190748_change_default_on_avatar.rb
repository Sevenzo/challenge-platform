class ChangeDefaultOnAvatar < ActiveRecord::Migration
  def change
    change_column :users, :avatar_option, :string, default: 'upload'
  end
end
