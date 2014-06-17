class ContactAccess < ActiveRecord::Base
  attr_accessible :contact_id, :user_id, :transaction_id
  belongs_to :user
  belongs_to :transaction
  
  def self.regenerate_for_transaction transaction_id, user_id, ids
    ContactAccess.destroy_by_transaction(transaction_id, user_id)
    ids.each do |id|
      ContactAccess.create(:contact_id => user_id, :user_id => id, :transaction_id => transaction_id)
      ContactAccess.create(:contact_id => user_id, :user_id => id, :transaction_id => nil) unless ContactAccess.check_exists(user_id, id) 
    end
  end
  
  def self.check_exists contact_id, user_id 
    ContactAccess.where(:contact_id => contact_id, :user_id => user_id, :transaction_id => nil)
  end
  
  def self.destroy_by_transaction transaction_id, user_id
    ContactAccess.where(:contact_id => user_id, :transaction_id => transaction_id).destroy_all
  end
end
