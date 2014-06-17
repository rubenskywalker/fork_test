require 'csv'
class ContactsController < ApplicationController
  before_filter :find_contact, :only => [:show, :edit, :extended, :update, :destroy]
  
  def index
    #User.contacts_only_for_user(current_user.id)
    @users = User.where(:id => current_user.contact_accesses.where(:transaction_id => nil).map(&:contact_id))
  end
  def role
    @role = Role.find(params[:id])
    @contacts = Contact.where(:role_id => params[:id])
    render :action => "index"
  end
  
  def make_guest
    @contact = User.find(params[:id])
    @contact.update_attributes(:contact_only => false)
    redirect_to :back
  end
  
  
  # GET /contacts/new
  # GET /contacts/new.json
  def new
    @contact = User.new
  end

  # GET /contacts/1/edit
  
  def export
    contacts = User.where(:id => current_user.contact_accesses.where(:transaction_id => nil).map(&:contact_id))
    csv_file = Contact.to_csv(contacts)
    send_data csv_file, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=contacts.csv"
  end
  
  
  
  def update
    if @contact.update_attributes(params[:user])
      redirect_to contacts_path, notice: 'Contact was successfully updated.'
    else
      render action: "edit", notice: 'Wrong data'
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  
  def destroy
    @contact.destroy
    redirect_to contacts_url, notice: 'Contact was successfully deleted.'
  end
  
  private
  def find_contact
    @contact = User.find(params[:id])
  end
end
