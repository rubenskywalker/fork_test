class PaymentItem < ActiveRecord::Base
  attr_accessible :company_id, :deleted_at, :itemable_id, :itemable_type
  belongs_to :itemable, :polymorphic => true
  belongs_to :company
end
