class AddCountyToTransactionDetail < ActiveRecord::Migration
  def change
    add_column :transaction_details, :county, :integer, :default => 0
    add_column :transaction_details, :acceptance_date, :integer, :default => 0
  end
end
