class Contact < ActiveRecord::Base
  attr_accessible :name, :user_id, :email, :company, :info, :first_name, :last_name, :address, :city, :state, :zip, :phone, :role_id, :fax
  has_many :attach_contacts, :dependent => :destroy
  has_many :transactions, :through => :attach_contacts
  belongs_to :role
  scope :sl, where(:role_id => 1)
  scope :ba, where(:role_id => 2)
  # FOR PRODUCTION CHECK
  def self.to_csv contacts
    csv_file = CSV.generate({}) do |csv|
    csv << ["First name", "Last name", "Company", "Email", "Phone"]
      contacts.each do |c|
        csv << [c.first_name, c.last_name, c.contact_company, c.no_email? ? "" : c.email, c.phone]
      end
    end
    csv_file
  end
  def self.move_to_my contact
    @existing_user = false
    @my_user = false
    generated_password = Devise.friendly_token.first(6)
    contact[:company_id] = @global_company.id
    if contact[:email].blank?
      contact[:email] = "#{generated_password}@app.piratetesternow.com"
      contact[:no_email] = 1
    else
      contact[:contact_only] = false
      contact[:is_guest] = true
    end
    contact[:contact_only] = true
    if @contact = User.find_by_email(contact[:email])
      @existing_user = true
      @my_user = true if current_user.contact_accesses.where(:transaction_id => nil).map(&:contact_id).include?(@contact.id)
      nil
    else
      @contact = User.new(contact)
      @contact.password = generated_password
      @contact.password_confirmation = generated_password
    end
   
    
    
    
    @contact.save!
    @contact.setup_permissions if @contact.location_permissions.empty?
    @contact.company_id = current_user.company_id
    DefaultMailer.send_pass(@contact, generated_password).deliver if @contact.send_welcome?
    @attach_contact = current_user.contact_accesses.create(:contact_id => @contact.id)
  end
end
