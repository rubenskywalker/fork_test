class AddRaToWidget < ActiveRecord::Migration
  def change
    add_column :widgets, :ra_for, :string
  end
end
