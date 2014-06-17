class SettingsUsersController < ApplicationController
  before_filter :find_existing, :only => [:create]
  before_filter :global_admin_access, :only => [:index]
  before_filter :super_update, :only => [:update, :smass_update]
  def index
    @settings_users = User.where(:company_id => @global_company.id).users_only
  end

  def show
    @settings_user = SettingsUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @settings_user }
    end
  end

  # GET /settings_users/new
  # GET /settings_users/new.json
  def new
    
    
    
    @settings_user = User.new()

    respond_to do |format|
      format.html {
        if @global_company.users_ended?
          redirect_to :back
        end
      }
      format.json { render json: @settings_user }
    end
  end

  # GET /settings_users/1/edit
  def edit
    @settings_user = User.find(params[:id])
  end

  # POST /settings_users
  # POST /settings_users.json
  def accept_invitation
    @invite = CompanyInvite.find(params[:id])
    user = @invite.user
    user.update_attributes(:is_guest => false, :company_id => @invite.company_id)
    user.setup_permissions
    
    redirect_to "/", notice: "User #{user.fullname} was successfully added to #{@invite.company.name}."
  end
  
  def existing_user
    @settings_user = User.find(params[:id])
  end
  
  def invitation_mail
    @settings_user = User.find(params[:id])
    @company_invite = @settings_user.company_invites.create(:company_id => @global_company.id)
    DefaultMailer.invitation_mail(current_user, @company_invite).deliver
    
    redirect_to settings_users_path, notice: 'Invitation mail was successfully sent.'
  end
  
  def create
    @settings_user = User.new(params[:user].merge!(company_id: @global_company.id, contact_company: @global_company.name, parent_id: current_user.id))
    if @settings_user.save
      redirect_to settings_users_path, notice: 'User was successfully created.'
    else
      render action: "new"
    end
  end
  
  def save_welcome_template
    current_user.welcome_templates.create(params[:welcome_template])
  end

  # PUT /settings_users/1
  # PUT /settings_users/1.json
  def dropbox_sync
    @settings_user = User.find(params[:id])
    DropboxoneWorker.perform_async(params[:id])
    redirect_to :back
  end
  
  def dropbox_sync_verify
    @settings_user = User.find(params[:id])
    DropboxverifyWorker.perform_async(params[:id])
    redirect_to :back
  end
  
  def dropbox_restore
    @settings_user = User.find(params[:id])
    DropboxrestoreWorker.perform_async(params[:id])
    redirect_to :back
  end
  
  
  def dropbox_code
    @settings_user = User.find(params[:id])
    @settings_user.update_attributes(:dropbox_code => DropboxSync.finish(params[:user][:dropbox_code]))
    redirect_to :back
  end
  

  def destroy
    @settings_user = User.find(params[:id])
    @settings_user.destroy
    redirect_to settings_users_url, notice: 'User was successfully deleted.' 
  end
  
  private
  
  def find_existing
    
    if @settings_user = User.find_by_email(params[:user][:email])
      redirect_to existing_user_settings_user_path(@settings_user)
    end
    
  end
  
  def super_update
    @settings_user = User.find(params[:id])
    
      if params[:user][:password].present?
        @settings_user.update_attributes(params[:user])
      else
        @settings_user.update_without_password(params[:user])
      end

      redirect_to settings_users_path, notice: 'User was successfully updated.' 
  end
end
