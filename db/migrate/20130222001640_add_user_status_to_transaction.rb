class AddUserStatusToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :user_status, :integer
  end
end
