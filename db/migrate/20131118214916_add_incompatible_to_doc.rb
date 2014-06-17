class AddIncompatibleToDoc < ActiveRecord::Migration
  def change
    add_column :docs, :incompatible, :boolean, :default => false
  end
end
