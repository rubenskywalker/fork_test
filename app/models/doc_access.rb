class DocAccess < ActiveRecord::Base
  attr_accessible :doc_id, :docable_id, :docable_type, :moved
  belongs_to :docable, :polymorphic => true
  belongs_to :doc
  
  after_create :add_recent_activity
  after_create :attach_users
  
  scope :only_ci, where(:docable_type => "ChecklistItem")
  scope :only_l, where(:docable_type => "Library")
  scope :moved, where(:moved => true)
  
  
  def attach_users
    self.doc.users << doc.user
    #if self.docable.class.name == "Transaction"
      #self.docable.attach_contacts.each do |c|
      #  self.doc.users << c.user
      #end
    #end
    
  end
  
  def check_filename_exist?
    self.docable.docs.map(&:filename).select{|c| c==self.doc.filename}.length > 1
  end
  
  def ra docable, message
    RecentActivity.create(:transaction_id => docable, 
                          :user_id =>  self.doc.user_id, 
                          :message =>  message) unless self.check_filename_exist?
  end
  
  
  def checklist_item_ra
    self.ra(self.docable.checklist.transaction.id, "added file #{self.doc.filename} to #{self.docable.name} of #{self.docable.checklist.checklist_master.name}")
  end
  
  def transaction_item_ra
    self.ra(self.docable.id, "added file #{self.doc.filename}")
  end
  
  def select_ra
    self.docable.class.name == "ChecklistItem" ? self.checklist_item_ra : self.transaction_item_ra
  end
  
  def check_no_pdf?
    self.docable.class.name == "Transaction" && self.docable.company.transaction_details.first.only_pdf? && !self.doc.filename.include?(".pdf")
  end
  
  def add_recent_activity
    unless self.doc.by_mail? || self.check_no_pdf?
      self.select_ra
    end
  end
  
end
