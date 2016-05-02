class AddFileToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :file, :string
  end
end
