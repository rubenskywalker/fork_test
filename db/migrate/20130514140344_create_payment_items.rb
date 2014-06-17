class CreatePaymentItems < ActiveRecord::Migration
  def change
    create_table :payment_items do |t|
      t.string :itemable_type
      t.integer :itemable_id
      t.integer :company_id
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
