class CreateRecentActivities < ActiveRecord::Migration
  def change
    create_table :recent_activities do |t|
      t.text :message
      t.integer :user_id
      t.integer :transaction_id

      t.timestamps
    end
  end
end
