class Dashboard < ActiveRecord::Base
  attr_accessible :listings, :recent_activity, :transaction_added, :transactions_alosing, :transactions_past, :transactions_summary, :user_id
  has_many :widgets, :dependent => :destroy
  belongs_to :user
end
