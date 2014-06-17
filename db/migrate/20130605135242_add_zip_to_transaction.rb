class AddZipToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :zip, :string
  end
end
