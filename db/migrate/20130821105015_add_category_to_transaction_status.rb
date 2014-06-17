class AddCategoryToTransactionStatus < ActiveRecord::Migration
  def change
    add_column :transaction_statuses, :category, :string
  end
end
