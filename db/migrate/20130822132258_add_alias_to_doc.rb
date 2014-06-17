class AddAliasToDoc < ActiveRecord::Migration
  def change
    add_column :docs, :alias, :string
  end
end
