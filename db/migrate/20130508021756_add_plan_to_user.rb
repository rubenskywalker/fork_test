class AddPlanToUser < ActiveRecord::Migration
  def change
    add_column :users, :plan, :string, :default => "none"
  end
end
