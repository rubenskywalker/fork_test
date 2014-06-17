class AddLockToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :lock, :boolean
  end
end
