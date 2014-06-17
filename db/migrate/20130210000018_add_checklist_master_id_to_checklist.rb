class AddChecklistMasterIdToChecklist < ActiveRecord::Migration
  def change
    add_column :checklists, :checklist_master_id, :integer
  end
end
