class AddCountyToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :county, :string
    add_column :transactions, :acceptance_date, :date
  end
end
