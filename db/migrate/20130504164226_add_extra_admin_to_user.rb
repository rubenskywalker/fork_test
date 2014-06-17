class AddExtraAdminToUser < ActiveRecord::Migration
  def change
    add_column :users, :extra_admin, :boolean
  end
end
