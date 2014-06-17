class CreateDocAccesses < ActiveRecord::Migration
  def change
    create_table :doc_accesses do |t|
      t.integer :doc_id
      t.integer :docable_id
      t.string :docable_type

      t.timestamps
    end
  end
end
