class AddUserIdToAttachContact < ActiveRecord::Migration
  def change
    add_column :attach_contacts, :user_id, :integer
  end
end
