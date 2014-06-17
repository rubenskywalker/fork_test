class AddAcceptUsersToUser < ActiveRecord::Migration
  def change
    add_column :users, :accept_users, :boolean, :default => false
  end
end
