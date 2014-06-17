class AddPositionToWidget < ActiveRecord::Migration
  def change
    add_column :widgets, :position, :integer
  end
end
