class AddSubCategoryToTransactionStatus < ActiveRecord::Migration
  def change
    add_column :transaction_statuses, :sub_category, :boolean, :default => false
  end
end
