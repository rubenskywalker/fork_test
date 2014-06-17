class CreateDashboards < ActiveRecord::Migration
  def change
    create_table :dashboards do |t|
      t.boolean :transactions_summary
      t.boolean :transactions_alosing
      t.boolean :transaction_added
      t.boolean :transactions_past
      t.boolean :recent_activity
      t.boolean :listings

      t.timestamps
    end
  end
end
