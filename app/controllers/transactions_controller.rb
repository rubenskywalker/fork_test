class TransactionsController < ApplicationController
  # GET /transactions
  # GET /transactions.json
  
  skip_before_filter :authenticate_user!, :only => [:mail_attachment]
  load_and_authorize_resource :except => [:autocomplete_user_fullname, :add_contact, :mail_attachment, :in_location, :in_status, :in_type,  :remove_contact]
  autocomplete :user, :fullname, :display_value => :fullname_email
  before_filter :find_transaction, :only => [:mail_attachment, :pdf, :lock, :add_contact, :edit, :remove_notification, :update, :destroy]
  after_filter :user_extra_params, :only => [:add_contact]
  after_filter :attach_contact, :only => [:add_contact, :add_new_contact]
  after_filter :attach_new_contact, :only => [:create]
  
  def get_autocomplete_items(parameters)
     super(parameters)
     items = User.search_by_fullname(params[:term], current_user.id).select{|c| c.inclede_contacts?(current_user) }
  end
  
  
  
  def mail_attachment
    # process various message parameters:
    
    actual_body = params["body-html"]

    user = User.find_by_mail_digest(recipient.split("-").first)
    @transaction.notes.create(:status => actual_body, :user_id => user.id, :by_mail => true, :mail_it => true, :extra_params => params) unless actual_body.blank? || !user
  
     
    render :text => "OK"
  end
  
  def search
		sort = params[:sort]
		sort = "created_at" if sort == "latest" || sort.blank?
		sort = "close_sate" if sort == "date"
    if params[:search]
			filters = {:name => params[:search], :mls => params[:search], :street => params[:search], :city => params[:search], :county => params[:search], :address_1 => params[:search], :address_2 => params[:search], :state => params[:search], :zip => params[:search]}
			@transaction = Transaction.new(:only_for_search => true)
      @transactions = @transaction.find_by_keyword(filters, @global_company, sort)
    else
			@transaction = Transaction.new(params[:transaction].merge({:only_for_search => true}))
      @transactions = @transaction.find_by_keyword(params[:transaction], @global_company, sort)
    end
    
    render :action => "index"
  end
  
  def index
		sort = params[:sort]
		sort = "created_at" if sort == "latest" || sort.blank?
		sort = "close_sate" if sort == "date"
    
    @transactions = Transaction.where("transactions.user_id IN (?) OR attach_contacts.user_id = ?", current_user.default_ids, current_user.id).includes(:attach_contacts).order("transactions.#{sort} ASC")
    @transaction = Transaction.new()

  end
  
  def in_location
    @transactions = Transaction.where(:location_id => params[:id])
    render :action => "index"
  end
  
  def in_status
    @transactions = Transaction.where(:transaction_status_id => params[:id])
    render :action => "index"
  end
  def in_type
    @transactions = Transaction.where(:transaction_type_id => params[:id])
    render :action => "index"
  end
  
  
  def pdf
    
  end
  # GET /transactions/1
  # GET /transactions/1.json
  def show
    transaction = Transaction.find(params[:id])
    @transaction = transaction.true_for_global(@global_company, current_user) ? transaction : not_found
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transaction }
    end
  end
  
  def lock
    lock = !@transaction.lock?
    @transaction.update_attributes(:lock => lock)
    redirect_to :back
  end
  
  def remove_contact
    ContactAccess.where(:contact_id => params[:id], :user_id => params[:user_id]).destroy_all
    unless params[:attach_contact].blank?
      AttachContact.find(params[:attach_contact]).destroy
    end
    redirect_to :back
  end

  def add_new_contact
    @contact = params[:user] ? User.as_contact(params[:user], current_user.company_id) : User.find_by_first_name_and_last_name(Company.split_name(params[:transaction][:company_name], 0), Company.split_name(params[:transaction][:company_name], 1))
  end
  
  
  def add_contact
    @contact = params[:user] ? User.as_contact(params[:user], current_user.company_id) : User.cuted_contact(params[:transaction][:company_name])
  end
  # GET /transactions/new
  # GET /transactions/new.json
  def new
    @page_title = "New Transaction"
    @transaction = Transaction.new
    @td = @global_company.transaction_details.first
    
    
    
    respond_to do |format|
      format.html {
        if @global_company.transactions_ended?
          redirect_to "/"
        end
      }
      format.json { render json: @transaction }
    end
  end

  # GET /transactions/1/edit
  
  def edit
    @td = @global_company.transaction_details.first
    
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = current_user.transactions.new(params[:transaction])
    
    respond_to do |format|
      if @transaction.save
        format.html { redirect_to transactions_path, notice: 'Transaction was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /transactions/1
  # PUT /transactions/1.json
  
  def remove_notification
    
    @ac = AttachContact.find(params[:user_id])
    RecentActivity.create(:transaction_id => @transaction.id, 
                          :user_id =>  current_user.id, 
                          :message =>  "Removed Contact: #{@ac.user.fullname} as #{@ac.role.name if @ac.role}")
    
    render :nothing => true
  end
  
  
  def update
    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  
  def destroy
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to transactions_url }
      format.json { head :no_content }
    end
  end
  
  private
  def user_extra_params
    @existing_user = !@contact.nil? && @contact.existing? ? true : false
  end
  
  def attach_new_contact
    @transaction.attach_contacts.create(:user_id => current_user.id, :role_id => params[:transaction][:my_role]) unless params[:transaction][:my_role].blank?
  end
  
  def attach_contact
    unless @contact.nil?
      @contact.setup_contact_params(current_user, @transaction)
      params[:user] ||= params[:transaction]
      @attach_contact = @contact.attach_contacts.create(:transaction_id => params[:id], :role_id => params[:user][:role_id], :attach_to_transaction => true)
    end
  end
  
  
  def body_mail
    @transaction = Transaction.find(params[:id])
    # process various message parameters:
    @global_sender  = params['sender']
    @global_subject = params['subject']
    @global_recipient = params['recipient']

    # get the "stripped" body of the message, i.e. without
    # the quoted part
    @global_body = params["body-html"]#params["stripped-text"]
  end
  
  
end
