class CreateInquiries < ActiveRecord::Migration
  def change
    create_table :inquiries do |t|
      t.string :email
      t.string :category
      t.text :subject
      t.text :message

      t.timestamps null: false
    end
  end
end
