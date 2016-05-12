class AddCommentsCountToSuggestions < ActiveRecord::Migration
  def change
    add_column :suggestions, :comments_count, :integer, nil: false, default: 0
  end
end
