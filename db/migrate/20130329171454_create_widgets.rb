class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.integer :dashboard_id
      t.string :widget_type
      t.date :widget_date
      t.integer :location_id

      t.timestamps
    end
  end
end
