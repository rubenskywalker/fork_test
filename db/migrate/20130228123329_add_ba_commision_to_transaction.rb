class AddBaCommisionToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :ba_commision, :integer
    add_column :transactions, :la_commision, :integer
  end
end
