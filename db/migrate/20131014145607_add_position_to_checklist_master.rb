class AddPositionToChecklistMaster < ActiveRecord::Migration
  def change
    add_column :checklist_masters, :position, :integer
  end
end
