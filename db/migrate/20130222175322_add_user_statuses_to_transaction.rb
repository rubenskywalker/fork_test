class AddUserStatusesToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :user_status_1, :boolean
    add_column :transactions, :user_status_2, :boolean
    add_column :transactions, :user_status_3, :boolean
  end
end
