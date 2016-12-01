class AddDrawingToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :drawing, :text
  end
end
