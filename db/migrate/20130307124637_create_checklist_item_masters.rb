class CreateChecklistItemMasters < ActiveRecord::Migration
  def change
    create_table :checklist_item_masters do |t|
      t.integer :checklist_master_id
      t.string :name

      t.timestamps
    end
  end
end
