class CreateChecklistPermissions < ActiveRecord::Migration
  def change
    create_table :checklist_permissions do |t|

      t.timestamps
    end
  end
end
