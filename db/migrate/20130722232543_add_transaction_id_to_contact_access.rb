class AddTransactionIdToContactAccess < ActiveRecord::Migration
  def change
    add_column :contact_accesses, :transaction_id, :integer
  end
end
