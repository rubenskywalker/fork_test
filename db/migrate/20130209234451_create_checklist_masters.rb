class CreateChecklistMasters < ActiveRecord::Migration
  def change
    create_table :checklist_masters do |t|
      t.string :name

      t.timestamps
    end
  end
end
