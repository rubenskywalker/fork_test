class CreatePngDocs < ActiveRecord::Migration
  def change
    create_table :png_docs do |t|
      t.integer :doc_id
      t.string :file

      t.timestamps
    end
  end
end
