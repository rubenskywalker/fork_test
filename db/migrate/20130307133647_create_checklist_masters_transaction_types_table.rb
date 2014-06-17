class CreateChecklistMastersTransactionTypesTable < ActiveRecord::Migration
  def self.up
      create_table :checklist_masters_transaction_types, :id => false do |t|
          t.references :checklist_master
          t.references :transaction_type
      end
      #add_index :checklist_masters_transaction_types, [:checklist_master_id, :transaction_type_id]
      #add_index :checklist_masters_transaction_types, [:transaction_type_id, :checklist_master_id]
    end

    def self.down
      drop_table :checklist_masters_transaction_types
    end
end
