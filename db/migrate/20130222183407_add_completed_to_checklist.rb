class AddCompletedToChecklist < ActiveRecord::Migration
  def change
    add_column :checklists, :completed, :boolean
  end
end
