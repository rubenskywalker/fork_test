class AddSortingToLibrary < ActiveRecord::Migration
  def change
    add_column :libraries, :sorting, :integer, :default => 0
  end
end
