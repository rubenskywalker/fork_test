class AddMovedToDocAccesse < ActiveRecord::Migration
  def change
    add_column :doc_accesses, :moved, :boolean
  end
end
