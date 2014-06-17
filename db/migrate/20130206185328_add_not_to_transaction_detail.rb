class AddNotToTransactionDetail < ActiveRecord::Migration
  def change
    add_column :transaction_details, :offer, :integer
    add_column :transaction_details, :pending, :integer
    add_column :transaction_details, :listing, :integer
  end
end
