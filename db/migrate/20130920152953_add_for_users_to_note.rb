class AddForUsersToNote < ActiveRecord::Migration
  def change
    add_column :notes, :for_users, :string, :default => ""
  end
end
