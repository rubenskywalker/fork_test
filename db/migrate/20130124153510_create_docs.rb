class CreateDocs < ActiveRecord::Migration
  def change
    create_table :docs do |t|
      t.string :file
      t.integer :user_id
      t.string :docable_type
      t.integer :docable_id

      t.timestamps
    end
  end
end
