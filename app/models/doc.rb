class Doc < ActiveRecord::Base
  attr_accessible :file, :user_id, :user_ids, :counter, :review, :users_assigned, :by_mail, :secret_key, :incompatible, :alias, :remote_file_url
  #belongs_to :docable, :polymorphic => true
  has_many :doc_accesses, :dependent => :destroy
  has_many :checklist_items, :through => :doc_accesses
  has_many :libraries, :through => :doc_accesses
  has_many :transactions, :through => :doc_accesses
  has_many :png_docs, :dependent => :destroy
  belongs_to :user
  has_and_belongs_to_many :users
  mount_uploader :file, TransactionFileUploader
  #after_create :make_alias
  #validates_format_of :alias, :with => /^[a-zA-Z\d ]*$/i
  #after_save :make_png
  
  
  
  scope :for_search, lambda { |sp| where("file ILIKE lower(?)", "%#{sp.downcase}%")}
  def filename
    File.basename(file.path)
  end
  
  private
  
  def make_alias
    self.alias = self.filename
    self.save
    #unless self.save!
    #  self.alias = "please_rename_#{Random.rand(21800).to_s}.pdf"
    #  self.save
    #end
  end
  
  
  
 
end
