class AddFileToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :file, :string
  end
end
