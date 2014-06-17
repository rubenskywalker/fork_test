class AddFieldsToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :mls, :string
    add_column :transactions, :street, :string
    add_column :transactions, :city, :string
    add_column :transactions, :status, :string
    add_column :transactions, :location_id, :string
    add_column :transactions, :close_sate, :date
  end
end
