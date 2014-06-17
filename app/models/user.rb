class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  # Setup accessible (or protected) attributes for your model
  attr_accessor :tmp_company, :plan_id, :stripe_card_token, :company_plan, :card_four, :free_plan, :existing
  attr_accessible :email, :password, :password_confirmation, :remember_me, :confirmed_at, :name, :location_permissions_attributes, :free_plan, :company_id, :tmp_company, :info, :first_name, :last_name, :address, :city, :state, :zip, :phone, :home_phone, :mobile_phone, :fax, :contact_only, :role_id, :p_all, :p_master, :p_library, :parent_id, :send_welcome, :welcome_subject, :welcome_message, :super_admin, :transaction_count, :accept_users, :plan, :plan_id, :stripe_card_token, :company_plan, :card_four, :contact_company, :avatar, :is_locked, :no_email, :is_guest, :mail_digest, :dropbox_code, :last_dropbox_backup, :dropbox_cursor
  has_many :location_permissions, :dependent => :destroy
  accepts_nested_attributes_for :location_permissions, :allow_destroy => true
  has_and_belongs_to_many :docs
  has_many :recent_activities, :dependent => :destroy
  has_many :dashboards, :dependent => :destroy
  has_many :transactions, :dependent => :destroy
  has_many :attach_contacts, :dependent => :destroy
  has_many :notes
  has_many :welcome_templates, :dependent => :destroy
  has_many :widgets, :dependent => :destroy
  has_many :contact_accesses, :dependent => :destroy
  has_many :company_invites, :dependent => :destroy
  
  mount_uploader :avatar, UserAvatarUploader
  
  has_many :payment_items, :as => :itemable
  
  PLANS = ["none", "trial", "payment"]
  
  belongs_to :role
  belongs_to :company
  
  scope :contacts_only, where(:contact_only => true)
  scope :contacts_only_for_user, lambda { |uid| where(:parent_id => uid) }
  scope :users_only, where(:no_email => nil)
  scope :search_by_fullname, lambda { |q, uid| where("(first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ?)", "%#{q.downcase}%", "%#{q.downcase}%", "%#{q.downcase}%")}
  
  after_create :add_company
  after_create :add_widgets
  after_save :send_welcome_mail
  
  validates_presence_of :first_name
  validates_presence_of :last_name
  
  
  scope :company_users, where(:is_guest => nil, :contact_only => nil)
  # attr_accessible :title, :body
  
  def fullname
    "#{self.first_name}  #{self.last_name}"
  end
  
  def inclede_contacts? extra_user
    (extra_user.contact_accesses.map(&:contact_id).include?(self.id) || self.company_id == extra_user.company_id)
  end
  
  def update_profile params
    
    case params[:name]
    when "password"
      self.update_attributes(:password => params[:value], :password_confirmation => params[:value])
    when "company_name"
      self.company.update_attributes(:name => params[:value])
    else
      seld.update_attributes(params[:name] => params[:value])
    end
    
  end
  
  def upgrade_stripe stripe_card_token, plan, card_four
    customer = Stripe::Customer.create(description: self.email, card: stripe_card_token)
    
    global_company = self.real_guest? ? self.add_guest_company : self.compny
    
    global_company.update_plan(customer.id, card_four, plan)
  end
  
  def self.auto_password
    Devise.friendly_token.first(6)
  end
  
  def self.auto_email
    "#{User.auto_password}@app.piratetesternow.com"
  end
  
  def self.as_contact user_params, company_id
    user = User.setup_as_contact(user_params, company_id)
    user.setup_permissions if !user.nil? && user.location_permissions.empty?
    user
  end
  
  def self.setup_as_contact user_params, company_id
    existing_user = User.find_by_email(params[:email]) rescue nil
    user = nil
    if existing_user.nil?
      user = User.new(user_params)
      user.setup_contact(company_id)
      user.save
    else
      user = existing_user
      user.existing = true
    end
    user
  end
  
  def setup_contact_params current_user, transaction
    ContactAccess.create(:contact_id => current_user.id, :user_id => self.id, :transaction_id => transaction.id)
    ContactAccess.create(:contact_id => self.id, :user_id => current_user.id)
    ContactAccess.create(:contact_id => self.id, :user_id => self.id, :transaction_id => transaction.id)
    DefaultMailer.send_pass(self, self.auto_password).deliver if self.send_welcome?
    current_user.contact_accesses.create(:contact_id => self.id)
      
    
  end
  
  def setup_contact company_id
    
    if self.email.blank?
      self.email = User.auto_email
      self.no_email = 1
    else
      self.contact_only = 0
      self.is_guest = 1
    end
    
    self.password = generated_password
    self.password_confirmation = generated_password
    self.company_id = company_id
  end
  
  def fullname_email
    "#{self.fullname} (#{self.email})"
  end
  
  def active_for_authentication?
    super && !self.is_locked?
  end
  
  def inactive_message
    "Sorry, this account has been deactivated."
  end
  
  def def_avatar
    self.avatar.blank? ? "/assets/avatar.jpg" : self.avatar.thumb.url
  end
  
  def default_ids
    User.where(:company_id => self.company_id).map(&:id)
  end
  
  def save_with_payment
    customer = Stripe::Customer.create(description: email, plan: plan_id, card: stripe_card_token)
    case company_plan
    when "user"
      self.company.update_plan_per_user
    when "transaction"
      self.company.update_plan_per_transaction
    end
  end
  
  def real_guest?
    self.is_guest? && !self.p_all?
  end
  
  def setup_permissions
    Location.where(:company_id => self.company_id).each do |location|
      self.location_permissions.create(:location_id => location.id)
    end
  end
  
  def add_guest_company
    company = Company.create(:name => "guest new company")
    self.update_attributes(:company_id => company.id, :is_guest => false, :super_admin => true)
    Location.create(:company_id => company.id, :name => "Main Office")
    self.payment_items.create(:company_id => self.company_id)
    return company
  end
  
  def mail_digest
    Digest::MD5.hexdigest(self.id.to_s)
  end
  
  def self.cuted_contact company_name=nil
    user = nil
    cuted_contact = company_name.split(" (")[0]
    user = User.find_by_first_name_and_last_name(cuted_contact.split("  ")[0], cuted_contact.split("  ")[1]) if company_name
    user
  end
  
  def create_company_blank
    if free_plan.blank?
      Company.create(:name => self.tmp_company)
    else
      Company.create(:name => self.tmp_company, :free_plan => true)
    end
  end
  
  private
  def add_company
    
    unless tmp_company.blank?
      company = self.create_company_blank
      self.update_attributes(:company_id => company.id)
      Location.create(:company_id => company.id, :name => "Main Office")
    end
    
    company.update_plan(self.id, self.card_four, self.company_plan.to_i) unless company_plan.blank?
    
    self.payment_items.create(:company_id => self.company_id)
  end
  
  def add_detete_at_to_payment_item
    self.payment_items.first.update_attributes(:deleted_at => Time.now) unless self.payment_items.empty?
  end
  
  def add_widgets
    Widget::TYPES.each do |key, value|
      self.widgets.create(:widget_type => value, :location_id => 0)
    end
  end
  
  def send_welcome_mail
    DefaultMailer.welcome(self).deliver if self.send_welcome?
  end
  
  
 
end
