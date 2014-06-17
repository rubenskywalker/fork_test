class AddTransactionStatusIdToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :transaction_status_id, :integer
  end
end
