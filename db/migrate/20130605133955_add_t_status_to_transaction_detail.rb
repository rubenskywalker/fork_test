class AddTStatusToTransactionDetail < ActiveRecord::Migration
  def change
    add_column :transaction_details, :t_status, :integer
    add_column :transaction_details, :t_type, :integer
  end
end
