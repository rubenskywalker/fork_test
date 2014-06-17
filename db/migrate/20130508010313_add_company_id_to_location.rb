class AddCompanyIdToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :company_id, :integer
    add_column :checklist_masters, :company_id, :integer
    add_column :transaction_details, :company_id, :integer
    
  end
end
