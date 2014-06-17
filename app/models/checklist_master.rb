class ChecklistMaster < ActiveRecord::Base
  attr_accessible :name, :checklist_item_masters_attributes, :transaction_type_ids, :lock, :company_id, :position
  has_many :checklists
  has_many :checklist_item_masters, :dependent => :destroy
  has_and_belongs_to_many :transaction_types
  belongs_to :company
  accepts_nested_attributes_for :checklist_item_masters, allow_destroy: true
  
  validates_presence_of :name
  default_scope order('position ASC')
  
  def self.sort_positions!(ids)
    ids.each_with_index do |id, index|
      ChecklistMaster.find(id).update_attributes(position: index + 1)
    end
  end
  
end
