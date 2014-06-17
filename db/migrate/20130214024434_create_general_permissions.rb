class CreateGeneralPermissions < ActiveRecord::Migration
  def change
    create_table :general_permissions do |t|

      t.timestamps
    end
  end
end
