class AddTextToNote < ActiveRecord::Migration
  def change
    remove_column :notes, :status
    add_column :notes, :status, :text
  end
end
