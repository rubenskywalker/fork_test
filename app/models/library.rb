class Library < ActiveRecord::Base
  attr_accessible :name, :is_default, :company_id, :sorting
  has_many :doc_accesses, :as => :docable, :dependent => :destroy
  has_many :docs, :through => :doc_accesses
  validates_presence_of :name
  
  belongs_to :company
end
