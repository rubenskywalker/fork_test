class AddMailDigestToUser < ActiveRecord::Migration
  def change
    add_column :users, :mail_digest, :string
  end
end
