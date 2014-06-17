class CreateTransactionStatuses < ActiveRecord::Migration
  def change
    create_table :transaction_statuses do |t|
      t.integer :transaction_detail_id
      t.string :name

      t.timestamps
    end
  end
end
