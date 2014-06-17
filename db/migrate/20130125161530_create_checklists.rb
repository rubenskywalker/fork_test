class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.string :name
      t.integer :transaction_id

      t.timestamps
    end
  end
end
