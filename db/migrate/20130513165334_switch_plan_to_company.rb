class SwitchPlanToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :switch_plan, :boolean, :default => false
  end
 
end
