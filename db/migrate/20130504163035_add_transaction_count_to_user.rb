class AddTransactionCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :transaction_count, :integer, :default => 1
  end
end
