class AddAddress1ToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :address_1, :string
    add_column :transactions, :address_2, :string
    add_column :transactions, :expiration_date, :date
    add_column :transactions, :list_price, :integer
    add_column :transactions, :sale_price, :integer
  end
end
