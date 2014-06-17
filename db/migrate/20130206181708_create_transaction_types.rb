class CreateTransactionTypes < ActiveRecord::Migration
  def change
    create_table :transaction_types do |t|
      t.integer :transaction_detail_id
      t.string :name

      t.timestamps
    end
  end
end
