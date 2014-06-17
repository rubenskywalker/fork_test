class AddMainToLibrary < ActiveRecord::Migration
  def change
    add_column :libraries, :is_default, :boolean
  end
end
