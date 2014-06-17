class AddWelcomeToUser < ActiveRecord::Migration
  def change
    add_column :users, :send_welcome, :boolean
    add_column :users, :welcome_subject, :string
    add_column :users, :welcome_message, :text
  end
end
