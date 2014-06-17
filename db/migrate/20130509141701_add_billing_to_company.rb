class AddBillingToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :plan_name, :string, :default => "Trial"
    add_column :companies, :trial, :boolean, :default => true
    add_column :companies, :price_per_user, :integer
    add_column :companies, :price_per_transaction, :integer
    add_column :companies, :trial_days, :integer, :default => 30
    add_column :companies, :transactions_included, :integer, :default => 5
    add_column :companies, :users_included, :integer, :default => 0
    add_column :companies, :monthly_fee, :integer
  end
end
