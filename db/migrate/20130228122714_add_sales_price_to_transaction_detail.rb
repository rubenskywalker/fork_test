class AddSalesPriceToTransactionDetail < ActiveRecord::Migration
  def change
    add_column :transaction_details, :sale_price, :integer
    add_column :transaction_details, :what_role, :integer
  end
end
