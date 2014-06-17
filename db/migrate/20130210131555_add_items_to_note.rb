class AddItemsToNote < ActiveRecord::Migration
  def change
    add_column :notes, :complete_items, :boolean
    add_column :notes, :incomplete_items, :boolean
  end
end
