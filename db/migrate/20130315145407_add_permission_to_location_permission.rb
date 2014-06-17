class AddPermissionToLocationPermission < ActiveRecord::Migration
  def change
    add_column :location_permissions, :l13, :boolean, :default => false
    add_column :location_permissions, :l14, :boolean, :default => false
    add_column :location_permissions, :l15, :boolean, :default => false
    add_column :location_permissions, :l16, :boolean, :default => false
    add_column :location_permissions, :l17, :boolean, :default => false
    add_column :location_permissions, :l18, :boolean, :default => false
  end
end
