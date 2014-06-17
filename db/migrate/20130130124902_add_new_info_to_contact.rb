class AddNewInfoToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :first_name, :string
    add_column :contacts, :last_name, :string
    add_column :contacts, :address, :string
    add_column :contacts, :city, :string
    add_column :contacts, :state, :string
    add_column :contacts, :zip, :string
    add_column :contacts, :phone, :string
    add_column :contacts, :fax, :string
  end
end
