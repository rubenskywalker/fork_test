class CreateDefaultPlans < ActiveRecord::Migration
  def change
    create_table :default_plans do |t|
      t.string :plan_name
      t.boolean :trial
      t.integer :price_per_user
      t.integer :price_per_transaction
      t.integer :trial_days, :integer
      t.integer :transactions_included
      t.integer :users_included
      t.integer :monthly_fee
    end
    DefaultPlan.create(  
       :plan_name => "Free", 
       :trial => false, 
       :price_per_user => 0, 
       :price_per_transaction => 0,
       :monthly_fee => 0,
       :transactions_included => 1,
       :users_included => 1
    )
    DefaultPlan.create(  
       :plan_name => "Trial", 
       :trial => true, 
       :price_per_user => 0, 
       :price_per_transaction => 0,
       :monthly_fee => 0,
       :transactions_included => 5,
       :users_included => 2
    )
    DefaultPlan.create(  
      :plan_name => "Pay Per User", 
      :trial => false, 
      :price_per_user => 5, 
      :price_per_transaction => 0,
      :monthly_fee => 10,
      :transactions_included => 0,
      :users_included => 2
    )
    DefaultPlan.create(  
       :plan_name => "Pay Per Transaction", 
       :trial => false, 
       :price_per_user => 0, 
       :price_per_transaction => 2,
       :monthly_fee => 10,
       :transactions_included => 5,
       :users_included => 0
    )
  end
end
