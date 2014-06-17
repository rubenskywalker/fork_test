class AddCheckedToTransactionType < ActiveRecord::Migration
  def change
    add_column :transaction_types, :checked, :boolean
  end
end
