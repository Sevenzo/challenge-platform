class AddNewDigestFrequencyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :digest_frequency, :integer, default: 0
  end
end
