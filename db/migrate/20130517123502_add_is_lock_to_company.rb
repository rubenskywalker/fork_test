class AddIsLockToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :is_lock, :boolean, :default => false
  end
end
