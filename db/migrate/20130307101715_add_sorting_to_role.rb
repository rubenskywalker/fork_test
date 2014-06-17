class AddSortingToRole < ActiveRecord::Migration
  def change
    add_column :roles, :sorting, :integer
  end
end
