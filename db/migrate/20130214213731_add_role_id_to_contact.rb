class AddRoleIdToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :role_id, :integer
  end
end
