class AddAllPermToUser < ActiveRecord::Migration
  def change
    add_column :users, :p_all, :boolean, :default => false
    add_column :users, :p_master, :boolean, :default => false
    add_column :users, :p_library, :boolean, :default => false
  end
end
