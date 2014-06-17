class AddContactCompanyToUser < ActiveRecord::Migration
  def change
    add_column :users, :contact_company, :string
  end
end
