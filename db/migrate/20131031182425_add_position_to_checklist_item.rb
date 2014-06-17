class AddPositionToChecklistItem < ActiveRecord::Migration
  def change
    add_column :checklist_items, :position, :integer
  end
end
