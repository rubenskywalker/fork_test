class AddDropboxCodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :dropbox_code, :text
  end
end
