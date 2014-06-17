class CreateLocationPermissions < ActiveRecord::Migration
  def change
    create_table :location_permissions do |t|
      t.integer :user_id
      t.integer :location_id
      t.boolean :l1
      t.boolean :l2
      t.boolean :l3
      t.boolean :l4
      t.boolean :l5
      t.boolean :l6
      t.boolean :l7
      t.boolean :l8
      t.boolean :l9
      t.boolean :l10
      t.boolean :l11
      t.boolean :l12
      t.timestamps
    end
  end
end
