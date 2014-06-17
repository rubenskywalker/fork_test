class AddPositionToChecklistItemMaster < ActiveRecord::Migration
  def change
    add_column :checklist_item_masters, :position, :integer
  end
end
