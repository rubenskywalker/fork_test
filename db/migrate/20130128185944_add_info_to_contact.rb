class AddInfoToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :email, :string
    add_column :contacts, :company, :string
    add_column :contacts, :info, :text
  end
end
