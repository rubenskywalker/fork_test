class CreateDocsUsersTable < ActiveRecord::Migration
  def self.up
      create_table :docs_users, :id => false do |t|
          t.references :doc
          t.references :user
      end
      add_index :docs_users, [:doc_id, :user_id]
      add_index :docs_users, [:user_id, :doc_id]
    end

    def self.down
      drop_table :docs_users
    end
end
