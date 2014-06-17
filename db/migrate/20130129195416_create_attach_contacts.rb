class CreateAttachContacts < ActiveRecord::Migration
  def change
    create_table :attach_contacts do |t|
      t.integer :contact_id
      t.integer :transaction_id
      t.integer :role_id

      t.timestamps
    end
  end
end
