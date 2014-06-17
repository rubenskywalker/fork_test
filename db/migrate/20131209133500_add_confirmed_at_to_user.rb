class AddConfirmedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :confirmed_at, :date
  end
end
