class AddCompanyIdToLibrary < ActiveRecord::Migration
  def change
    add_column :libraries, :company_id, :integer
  end
end
