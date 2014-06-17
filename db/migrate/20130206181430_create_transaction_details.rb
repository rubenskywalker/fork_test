class CreateTransactionDetails < ActiveRecord::Migration
  def change
    create_table :transaction_details do |t|
      t.boolean :l1
      t.integer :l1n
      t.integer :address_1
      t.integer :address_2
      t.integer :city
      t.integer :state
      t.integer :zip
      t.integer :mls
      t.integer :close_date
      t.integer :expiration_date
      t.integer :list_price
      t.integer :ba_commision
      t.integer :la_commision
      t.integer :commision_note
      t.integer :transaction_format

      t.timestamps
    end
  end
end
