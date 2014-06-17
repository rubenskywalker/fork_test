class Checklist < ActiveRecord::Base
  attr_accessible :name, :transaction_id, :checklist_master_id, :completed
  belongs_to :transaction
  belongs_to :checklist_master
  has_many :checklist_items, :dependent => :destroy
  
  scope :completed, where(:completed => true)
  
  after_create :add_checklist_items_from_master
  
  private
  
  def add_checklist_items_from_master
    master = self.checklist_master
    master.checklist_item_masters.each do |cim|
      self.checklist_items.create(:name => cim.name)
    end
  end
  
  
end
