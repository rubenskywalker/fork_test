class AddCheckedToChecklistItem < ActiveRecord::Migration
  def change
    add_column :checklist_items, :checked, :boolean
  end
end
