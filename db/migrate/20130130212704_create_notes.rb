class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :transaction_id
      t.integer :checklist_id
      t.string :status
      t.integer :user_id

      t.timestamps
    end
  end
end
