class ChecklistItemMaster < ActiveRecord::Base
  attr_accessible :checklist_master_id, :name, :position
  belongs_to :checklist_master
  
  validates_presence_of :name
  default_scope order('position ASC')
end
