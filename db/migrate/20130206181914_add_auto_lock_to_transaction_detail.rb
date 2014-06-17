class AddAutoLockToTransactionDetail < ActiveRecord::Migration
  def change
    add_column :transaction_details, :auto_lock, :boolean
  end
end
