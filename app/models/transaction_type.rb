class TransactionType < ActiveRecord::Base
  attr_accessible :name, :transaction_detail_id, :checked
  belongs_to :transaction_detail
  has_many :transactions
  has_and_belongs_to_many :checklist_masters
  scope :checked_only, where(:checked => true)
  
  scope :for_company, lambda { |company_id| where("transaction_details.company_id = ?", company_id).includes(:transaction_detail)}
  
end
