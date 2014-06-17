class AddCheckedToTransactionStatus < ActiveRecord::Migration
  def change
    add_column :transaction_statuses, :checked, :boolean
  end
end
