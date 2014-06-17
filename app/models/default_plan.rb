class DefaultPlan < ActiveRecord::Base
  attr_accessible :plan_name, :trial, :price_per_user, :price_per_transaction, :monthly_fee, :transactions_included, :users_included

  PLANS = ["Trial", "Free", "Individual", "Team", "Small Office", "Medium Office", "Large Office", "Enterprise"]
  PRICES = [0, 0, 20, 35, 50, 100, 150, 0]
  USERS_INCLUDED = [0, 0, 2, 5, 10, 25, 50 ,0]
  PRICE_PER_USER = [0, 0, 10, 7, 5, 4, 3, 0]
  
  
  def self.create_plans
    DefaultPlan::PLANS.each_with_index do |p, index|
      plan = DefaultPlan.find_or_create_by_plan_name(p)
      plan.update_attributes(  
         :plan_name => p, 
         :trial => p == DefaultPlan::PLANS[0] ? true : false, 
         :price_per_user => DefaultPlan::PRICE_PER_USER[index], 
         :price_per_transaction => 0,
         :monthly_fee => DefaultPlan::PRICES[index],
         :transactions_included => p == DefaultPlan::PLANS[1] ? 5 : 0,
         :users_included => DefaultPlan::USERS_INCLUDED[index]
      )
    end
  end
end
