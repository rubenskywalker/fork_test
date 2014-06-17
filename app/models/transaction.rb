class Transaction < ActiveRecord::Base
  attr_accessor :company_name, :role_id, :my_role, :close_sate_from, :close_sate_to, :acceptance_date_from, :acceptance_date_to, :expiration_date_from, :expiration_date_to, :list_price_from, :list_price_to, :sale_price_from, :sale_price_to, :only_for_search, :extra_params
  attr_accessible :extra_params, :name, :company_id, :user_id, :mls, :street, :status, :location_id, :close_sate, :close_sate_from, :close_sate_to, :city, :company_name, :acceptance_date, :county,  :transaction_type_id, :lock, :user_status, :user_status_1, :user_status_2, :user_status_3, :role_id, :address_1, :address_2, :expiration_date, :expiration_date_from, :expiration_date_to, :list_price, :list_price_from, :list_price_to, :sale_price, :sale_price_from, :sale_price_to, :state, :transaction_status_id, :la_commision, :ba_commision, :commision_note, :my_role, :attach_contacts_attributes, :only_for_search, :zip
  belongs_to :location
  belongs_to :user
  belongs_to :company
  has_many :doc_accesses, :as => :docable, :dependent => :destroy
  has_many :docs, :through => :doc_accesses
  has_many :checklists, :dependent => :destroy
  has_many :attach_contacts, :dependent => :destroy
  has_many :contacts, :through => :attach_contacts
  has_many :notes, :dependent => :destroy
  belongs_to :transaction_type
  belongs_to :transaction_status
  has_many :contact_accesses, :dependent => :destroy
  
  has_many :payment_items, :as => :itemable
  
  validates_presence_of :location_id
  
  #validates_format_of :address_1, :with => /^[a-zA-Z\d\s:.-]*$/i
  #validates_format_of :address_2, :with => /^[a-zA-Z\d\s:.-]*$/i
  #validates_format_of :city, :with => /^[a-zA-Z\d\s:.-]*$/i
  
  
  accepts_nested_attributes_for :attach_contacts, :allow_destroy => true
  
  has_many :checklist_items, :through => :checklists
  has_many :recent_activities, :dependent => :destroy
  
  scope :for_search, lambda { |sp, user_ids| where("transactions.mls ILIKE ? OR transactions.city ILIKE ? OR transactions.address_1 ILIKE ? OR (attach_contacts.transaction_id = transactions.id AND attach_contacts.user_id IN (?))", "%#{sp.downcase}%", "%#{sp.downcase}%", "%#{sp.downcase}%", user_ids).includes(:attach_contacts)}
  scope :for_status, lambda { |status| where(:status => status)}
  
  
  scope :widget_transactions_past, where("close_sate < ?", Time.now())
  scope :widget_transactions_alosing, where("close_sate > ? AND close_sate < ?", Time.now(), (Time.now())+30.days )
  scope :widget_transaction_added, where("created_at > ?", (Time.now())-30.days )
  scope :widget_unreviewed_documents, where("docs.review is NULL").includes(:docs)
  scope :widget_month_status, lambda { |date_from, date_to, status_id| where("transactions.created_at > ? AND transactions.created_at < ? AND transactions.transaction_status_id = ?", date_from, date_to, status_id) }
  scope :widget_month_total, lambda { |date_from, date_to| where("transactions.created_at > ? AND transactions.created_at < ?", date_from, date_to) }
  scope :widget_month_status_by_category, lambda { |date_from, date_to, status_category| where("transactions.created_at > ? AND transactions.created_at < ? AND transaction_statuses.category = ?", date_from, date_to, status_category).includes(:transaction_status) }
  scope :widget_listing, where("transaction_status_id IN (?)", TransactionStatus.where(:category => "Listing").map(&:id))
  
  # FOR SSEARCH
  
  scope :by_mls, lambda { |s| where("transactions.mls = ? OR transactions.mls ILIKE ?", s, "%#{s.downcase}%") }
  scope :by_address_1, lambda { |s| where("transactions.address_1 = ? OR transactions.address_1 ILIKE ?", s, "%#{s.downcase}%") }
  scope :by_address_2, lambda { |s| where("transactions.address_2 = ? OR transactions.address_2 ILIKE ?", s, "%#{s.downcase}%") }
  scope :by_city, lambda { |s| where("transactions.city = ? OR transactions.city ILIKE ?", s, "%#{s.downcase}%") }
  scope :by_state, lambda { |s| where("transactions.state = ?", s) }
  scope :by_transaction_status_id, lambda { |s| where("transactions.transaction_status_id = ?", s.to_i) }
  scope :by_close_sate_from, lambda { |s| where("transactions.close_sate >= ?", s) }
  scope :by_close_sate_to, lambda { |s| where("transactions.close_sate <= ?", s) }
  scope :by_acceptance_date_from, lambda { |s| where("transactions.acceptance_date >= ?", s) }
  scope :by_acceptance_date_to, lambda { |s| where("transactions.acceptance_date <= ?", s) }
  scope :by_expiration_date_from, lambda { |s| where("transactions.expiration_date >= ?", s) }
  scope :by_expiration_date_to, lambda { |s| where("transactions.expiration_date <= ?", s) }
  scope :by_list_price_from, lambda { |s| where("transactions.list_price >= ?", s.to_i) }
  scope :by_list_price_to, lambda { |s| where("transactions.list_price <= ?", s.to_i) }
  scope :by_sale_price_from, lambda { |s| where("transactions.sale_price >= ?", s.to_i) }
  scope :by_sale_price_to, lambda { |s| where("transactions.sale_price <= ?", s.to_i) }
  scope :by_location_id, lambda { |s| where("transactions.location_id = ?", s.to_i) }
  
  
  
  
  STATUSES = ["Status 1", "Status 2", "Status 3"]
  after_create :add_checklists_from_master
  after_create :create_mailgun
  after_create :add_to_company
  before_destroy :destroy_mailgun
  before_destroy :add_detete_at_to_payment_item
  after_save :update_with_keys
  
  def slug
    10000+(id*3)
  end
  
  def to_param
    [id, slug].join("-")
  end
  
  def true_for_global global_company, current_user
    self.company_id == global_company.id || transaction.attach_contacts.map(&:user_id).include?(current_user.id)
  end
  
  def self.widget_month_status_by_categories transactions, date_from, date_to, status_category
    date_param = "created_at"
    case status_category
      when "Pending"
        date_param = "close_sate"
      when "Closed"
        date_param = "close_sate"
      when "Expired"
        date_param = "expiration_date"
      else
        date_param = "created_at"
    end
    
    transactions.where("transactions.#{date_param} > ? AND transactions.#{date_param} < ? AND transaction_statuses.category = ?", date_from, date_to, status_category).includes(:transaction_status)
  end
  
  def mail_activity params, i
    doc = self.docs.create(:file => params["attachment-#{i+1}"], :user_id => user.id, :by_mail => true)
    if self.docs.map(&:alias).select{|c| c==doc.alias}.length > 1
      recent_activity_attachments = "Duplicate file #{doc.filename} wasn't uploaded.</br>"
      doc.destroy()
    elsif @transaction.company.transaction_details.first.only_pdf? && !doc.filename.include?(".pdf")
      recent_activity_attachments = "Non-pdf file #{doc.alias} wasn't uploaded.</br>"
      doc.destroy()
    else
      recent_activity_attachments = "#{doc.filename}</br>"
    end
    recent_activity_attachments
  end
  
  def changed_keys params
    changed_keys = []
    self.attributes.each do |key, value|
      if params[:transaction][key] &&  key != "transaction_status_id" && params[:transaction][key].to_s != value.to_s 
        
        case key.to_s
        when "mls"
          "MLS"
        when "close_sate"
          "close_date"
        when "ba_commision"
          "BA commision"
        when "la_commision"
          "LA commision"
        else
          key
        end
        
        changed_keys << key
      end
    end
    changed_keys
  end
  
  def status_keys params
    status_keys = []
    self.attributes.each do |key, value|
      if params[:transaction][key] && key == "transaction_status_id" && params[:transaction][key].to_s != value.to_s 
        status_keys << (value.blank? ? 'NONE' : TransactionStatus.find(value).name)
        status_keys << TransactionStatus.find(params[:transaction][:transaction_status_id]).name
      end
    end
    status_keys
  end
  
  # def single_search search, company
  #   user_ids = User.where("first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ?", "%#{search}%", "%#{search}%", "%#{search}%").map(&:id)
  #   transaction = company.transactions.order("transactions.created_at DESC")
  #   transaction = transaction.for_search(search, user_ids)
  #   transaction
  # end

  # def ssearch search, company
  #   transaction = company.transactions.order("created_at DESC")
  #   search.each do |k|
  #     transaction = transaction.send("by_k", search[k]) unless search[k].blank?
  #   end
  #   transaction
  # end

  def find_by_keyword search, company, order="created_at"
		order = "created_at" if order.blank?
    transactions = company.transactions
		conditions = []
    search.each do |k|
			conditions << "#{k[0]} ILIKE '%#{k[1]}%'" unless k[1].blank?
    end
    transactions.where(conditions.join(" OR ")).order("#{order} ASC")
  end
  
  def mail_digest
    Digest::MD5.hexdigest(self.id.to_s)
  end
  
  def user_mail_digest user
    "#{user.mail_digest[0..7]}-#{self.mail_digest[8..14]}-#{self.mail_digest[5..12]}"
  end
  
  def full_mail_digest
    "#{self.mail_digest[0..7]}-#{self.mail_digest[8..14]}-#{self.mail_digest[5..12]}"
  end
  
  def user_mail_attachment user
    
    user.update_attributes(:mail_digest => user.mail_digest[0..7] )
    mail_digest = self.user_mail_digest(user)
    mail = "#{mail_digest}@#{Mailgun.domain}"
    
    self.mailgun_mail(mail, mail_digest)
    
    return mail
  end
  
  def mailgun_mail mail, mail_digest
    my_site = "http://app.piratetesternow.com"
    
    @mailgun = Mailgun()
    
    unless @mailgun.mailboxes.list.map{|c| c["mailbox"]}.include?(mail)
      
      @mailgun.mailboxes.create mail_digest, "#{self.id}_246pass"
      
      @mailgun.routes.create "Transaction #{self.id} attachment route", 1,
           [:match_recipient, mail],
           [[:forward, "#{my_site}/transactions/#{self.id}/mail_attachment"],
            [:stop]]
    end
    
  end
  
  def mail_attachment
    "#{self.full_mail_digest}@#{Mailgun.domain}"
  end
  
  
  def tname
    "#{self.address_1}, #{self.address_2}, #{self.city}, #{self.state}"
  end
  
  
 
 
 def mail_recent_activity user, message
   RecentActivity.create(:transaction_id => self.id, 
                         :user_id =>  user.id, 
                         :message => message)
   
 end
  private
  
  def update_with_keys
    unless self.extra_params.blank?
      RecentActivity.create_for_transaction(@transaction, self.user, self.changed_keys(extra_params), self.status_keys(extra_params))
    end
  end
  
  def create_mailgun
    my_site = "http://app.piratetesternow.com"
    @mailgun = Mailgun()
    @mailgun.mailboxes.create self.full_mail_digest, "#{self.id}_246pass"
   
    @mailgun.routes.create "Transaction #{self.id} attachment route", 1,
         [:match_recipient, self.mail_attachment],
         [[:forward, "#{my_site}/transactions/#{self.id}/mail_attachment"],
          [:stop]]
  end
  
  
  def add_to_company
    self.update_attributes(:company_id => self.user.company_id)
    self.payment_items.create(:company_id => self.user.company_id)
  end
  
  def add_detete_at_to_payment_item
    self.payment_items.first.update_attributes(:deleted_at => Time.now) unless self.payment_items.empty?
  end
  
  def destroy_mailgun
    #@mailgun = Mailgun()
    #@mailgun.mailboxes.destroy self.mail_attachment
  end
  
  def add_checklists_from_master
    tt = self.transaction_type
    tt.checklist_masters.each do |master|
      self.checklists.create(:checklist_master_id => master.id)
    end unless tt.blank?
  end
  
end
