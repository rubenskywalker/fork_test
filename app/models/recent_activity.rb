class RecentActivity < ActiveRecord::Base
  attr_accessible :message, :transaction_id, :user_id, :note_id
  belongs_to :user
  belongs_to :transaction
  belongs_to :note
  
  
  def self.create_for_transaction transaction, current_user, changed_keys, status_keys
    RecentActivity.create(:transaction_id => @ransaction.id, 
                          :user_id =>  current_user.id, 
                          :message =>  "Edited Transaction Details: #{changed_keys.map{|l| l.humanize}.join(', ')}") unless changed_keys.empty?
    
    RecentActivity.create(:transaction_id => transaction.id, 
                        :user_id =>  current_user.id, 
                        :message =>  "Transaction status changes: Status Updated #{status_keys[0] == 'NONE' ? '' : 'from '+status_keys[0].to_s} to #{status_keys[1]}") unless  status_keys.empty?  
  end
end
