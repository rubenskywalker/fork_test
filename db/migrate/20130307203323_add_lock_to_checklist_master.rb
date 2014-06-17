class AddLockToChecklistMaster < ActiveRecord::Migration
  def change
    add_column :checklist_masters, :lock, :boolean, :default => false
  end
end
