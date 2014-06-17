class AddLastDropboxBackupToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_dropbox_backup, :datetime
  end
end
