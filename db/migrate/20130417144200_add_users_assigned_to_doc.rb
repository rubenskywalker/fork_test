class AddUsersAssignedToDoc < ActiveRecord::Migration
  def change
    add_column :docs, :users_assigned, :boolean
  end
end
