class ChecklistItem < ActiveRecord::Base
  
  attr_accessible :checklist_id, :name, :checked, :position
  has_many :doc_accesses, :as => :docable, :dependent => :destroy
  
  has_many :docs, :through => :doc_accesses
  belongs_to :checklist
  
  scope :checked_only, where(:checked => true)
  scope :unchecked_only, where("checked IS ? OR checked = ?", nil, false)
  
  after_save :change_checklist
  
  def self.sort_positions!(ids)
    ids.each_with_index do |id, index|
      ChecklistItemMaster.find(id).update_attributes(position: index + 1)
    end
  end
  
  private
  def change_checklist
    self.checklist.update_attributes(:completed => self.checklist.checklist_items.map(&:checked).include?(false) ? false : true )
    transaction = self.checklist.transaction
    #transaction.update_attributes(:lock => true) if !transaction.checklists.map(&:completed).include?(false) && TransactionDetail.first.auto_lock?
  end
  
  
end
