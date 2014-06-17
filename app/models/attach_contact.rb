class AttachContact < ActiveRecord::Base
  attr_accessor :attach_to_transaction
  attr_accessible :contact_id, :role_id, :transaction_id, :user_id, :attach_to_transaction
  belongs_to :transaction
  belongs_to :user
  belongs_to :role
  scope :sl, where(:role_id => 1)
  scope :ba, where(:role_id => 2)
  
  validates_presence_of :role_id, :message => "Please select a role for this contact"
  
  after_create :attach_users
  after_create :attach_ra
  before_destroy :create_ra
  
  private
  
  def attach_ra
    RecentActivity.create(:transaction_id => self.transaction_id, 
                          :user_id =>  self.transaction.user_id, 
                          :message =>  "added #{self.user.first_name} #{self.user.last_name} as a #{self.role.name if self.role}") if self.attach_to_transaction?
    
  end
  
  def attach_users
    self.transaction.docs.each do |d|
      d.users << self.user
    end
  end
  
  def create_ra
    RecentActivity.create(:transaction_id => self.transaction.id, 
                        :user_id =>  self.transaction.user_id, 
                        :message =>  "Contact removed #{self.user.first_name} #{self.user.last_name} as a #{self.role.name if self.role} to transaction")
 
  end
  
end
