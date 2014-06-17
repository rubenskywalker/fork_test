class Company < ActiveRecord::Base
  attr_accessor :free_plan
  attr_accessible :name, :plan_name, :free_plan, :stripe_card_token, :card_four, :trial, :price_per_user, :price_per_transaction, :trial_days, :users_included, :transactions_included, :monthly_fee, :switch_plan, :is_lock
  has_many :users, :dependent => :destroy
  has_many :locations, :dependent => :destroy
  has_many :checklist_masters, :dependent => :destroy
  has_many :transaction_details, :dependent => :destroy
  has_many :libraries, :dependent => :destroy
  has_many :transactions, :dependent => :destroy
  has_many :payment_items, :dependent => :destroy
  has_many :company_invites, :dependent => :destroy

  
  after_create :setup_stuff
  
  
  def self.split_name name, num
    name.split("  ")[num]
  end
  
  def days_from_creation
    (Time.now - self.created_at).to_i / 1.day
  end
  
  def users_ended?
    ((self.users_included <= (self.users.company_users.length - 1) ) && self.users_included != 0)  && self.trial?
  end
  
  def disabled?
    self.is_lock?
  end
  
  def transactions_ended?
    (((self.transactions_included <= self.transactions.length) && self.transactions_included != 0) && (self.trial? || self.real_free?))
  end
  
  def owner_company_name
    owner = User.where(:super_admin => true, :company_id => self.id).first
    owner.nil? ? self.name : "#{owner.fullname} (#{self.name})"
  end
  
  def trial_ended?
    ((self.days_from_creation.to_i >= self.trial_days) && self.trial?)
  end
  
  def real_free?
    self.plan_name == "Free"
  end
  
  def free_transaction_over?
    self.real_free? && self.transactions.length > 4
  end
  
  def get_plan_per_transaction
    DefaultPlan.where(:plan_name => "Pay Per Transaction").first
  end
  
  def get_plan_per_user
    DefaultPlan.where(:plan_name => "Pay Per User").first
  end
  
  def get_plan_trial
    DefaultPlan.where(:plan_name => "Trial").first
  end
  
  def get_plan_free
    DefaultPlan.where(:plan_name => "Free").first
  end
  
  
  def plan_per_transaction_monthly
    ((self.plan_transaction_length > self.transactions_included) && self.transactions_included != 0) ? ((self.plan_transaction_length - self.transactions_included) * self.price_per_transaction) + self.monthly_fee : self.monthly_fee
  end
  
  def plan_transaction_length
    time_now = Time.now
    self.payment_items.where(:itemable_type => "Transaction", :created_at => time_now.beginning_of_month..time_now.end_of_month).delete_if{|i| !i.deleted_at.blank? && (i.deleted_at + 30.days <= Time.now || i.deleted_at - 1.day <= i.created_at) }.length
  end
  
  def plan_users_amount_monthly
    amount = 0
    price_per_day = self.price_per_user.to_f / Time.now.end_of_month.day
    
    self.payment_items.where(:itemable_type => "User").offset(self.users_included).delete_if{|i| !i.deleted_at.blank? && (i.deleted_at + 30.days <= Time.now || i.deleted_at - 1.day <= i.created_at) }.each do |u|

      if (u.created_at + u.created_at.end_of_month.day.days) <= Time.now
        amount = price_per_day * Time.now.day.to_f
      else
        amount = ((Time.now.day + 1) - u.created_at.day) * price_per_day
      end

    end
    amount
  end
  
  def plan_per_user_monthly
    ((self.users.length > self.users_included) && self.users_included != 0) ? self.plan_users_amount_monthly + self.monthly_fee : self.monthly_fee
  end
  
  def update_plan_per_transaction card_token, card_four
    self.update_attributes(:plan_name => self.get_plan_per_transaction.plan_name, 
                           :trial => self.get_plan_per_transaction.trial, 
                           :price_per_user => self.get_plan_per_transaction.price_per_user, 
                           :price_per_transaction => self.get_plan_per_transaction.price_per_transaction,
                           :monthly_fee => self.get_plan_per_transaction.monthly_fee,
                           :transactions_included => self.get_plan_per_transaction.transactions_included,
                           :users_included => self.get_plan_per_transaction.users_included,
                           :stripe_card_token => card_token,
                           :card_four => card_four
                          )
  end
  
  def update_plan_per_user card_token, card_four
    self.update_attributes(:plan_name => self.get_plan_per_user.plan_name, 
                           :trial => self.get_plan_per_user.trial, 
                           :price_per_user => self.get_plan_per_user.price_per_user, 
                           :price_per_transaction => self.get_plan_per_user.price_per_transaction,
                           :monthly_fee => self.get_plan_per_user.monthly_fee,
                           :transactions_included => self.get_plan_per_user.transactions_included,
                           :users_included => self.get_plan_per_user.users_included,
                           :stripe_card_token => card_token,
                           :card_four => card_four
                          )
    
  end
  
  def update_plan card_token, card_four, plan_id
    self.update_attributes(:plan_name => DefaultPlan::PLANS[plan_id], 
                           :trial => false, 
                           :price_per_user => DefaultPlan::PRICE_PER_USER[plan_id], 
                           :price_per_transaction => 0,
                           :monthly_fee => DefaultPlan::PRICES[plan_id],
                           :transactions_included => 0,
                           :users_included => DefaultPlan::USERS_INCLUDED[plan_id],
                           :stripe_card_token => card_token,
                           :card_four => card_four
                          )
  end
  
  def update_plan_trial
    self.update_attributes(:plan_name => self.get_plan_trial.plan_name, 
                           :trial => get_plan_trial.trial, 
                           :transactions_included => get_plan_trial.transactions_included,
                           :users_included => get_plan_trial.users_included
                          )
  end
  
  def update_plan_free
    self.update_attributes(:plan_name => self.get_plan_free.plan_name, 
                           :trial => false, 
                           :transactions_included => get_plan_free.transactions_included,
                           :users_included => get_plan_free.users_included
                          )
  end
  
  private
  def setup_stuff
    td = TransactionDetail.create(:company_id => self.id)
    TransactionType.create(:transaction_detail_id => td.id, :name => "Residential", :checked => true)
    TransactionType.create(:transaction_detail_id => td.id, :name => "Commercial", :checked => true)
    #TransactionStatus.create(:transaction_detail_id => td.id, :name => "Active", :checked => true)
    #TransactionStatus.create(:transaction_detail_id => td.id, :name => "Listing", :checked => true)
    #TransactionStatus.create(:transaction_detail_id => td.id, :name => "Pending", :checked => true)
    #TransactionStatus.create(:transaction_detail_id => td.id, :name => "Closed", :checked => true)
    #TransactionStatus.create(:transaction_detail_id => td.id, :name => "Cancelled", :checked => true)
    TransactionStatus::STATUSES.each do |status|
      TransactionStatus.create(:transaction_detail_id => td.id, :name => status, :checked => true, :category => status, :sub_category => true)
    end
    Library.create(:company_id => self.id, :is_default => true, :name => "Documents Admin Only", :sorting => 1)
    Library.create(:company_id => self.id, :is_default => false, :name => "Documents", :sorting => 0)
    
    
    self.free_plan.blank? ? self.update_plan_trial : self.update_plan_free
    
  end
  
end
