class TransactionStatus < ActiveRecord::Base
  attr_accessible :name, :transaction_detail_id, :checked, :sub_name, :sub_category, :category
  belongs_to :transaction_detail
  has_many :transactions
  scope :checked_only, where(:checked => true)
  STATUSES = ["Active", "Listing", "Pending", "Closed", "Cancelled", "Expired"]
  
  validates_uniqueness_of :name, :scope => [:transaction_detail_id]
  
  scope :for_company, lambda { |company_id| where("transaction_details.company_id = ?", company_id).includes(:transaction_detail)}
  default_scope order('transaction_statuses.sub_category ASC')
  
  #before_create :add_sub_category
  
  private
  
  #def add_sub_category
  #  short_name = self.name
  #  self.name = "#{self.sub_name} - #{self.name}" if self.sub_category?
  #end
end
