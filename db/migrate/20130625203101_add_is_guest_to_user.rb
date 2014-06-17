class AddIsGuestToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_guest, :boolean
  end
end
