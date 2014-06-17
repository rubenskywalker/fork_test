class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  skip_before_filter :authenticate_user!, :only => [:check_pass]
  before_filter :find_user, :only => [ :show, :profile, :assign_contact, :lock, :update, :destroy]
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def show

  end
  
  def profile
    @user.update_profile(params)
    render :nothing => true
  end
  
  
  def assign_contact
    @transaction = Transaction.find(params[:transaction_id])
    ContactAccess.regenerate_for_transaction(@transaction.id, params[:id], params[:file_ids])
  end
  
  def company
    @company = Company.find(params[:id])
    @company.update_attributes(params[:name] => params[:value])
    render :nothing => true
  end
  
  
  def lock
    is_locked = !@user.is_locked?
    @user.update_attributes(:is_locked => is_locked)
    
    redirect_to :back
  end
  
  def switch_user
    user = User.find(params[:user_id])
    sign_in(:user, user)
    session[:switched_user] = true
    redirect_to "/", notice: "You are accessing app as #{user.email}"
  end

  def switch_to_admin
    redirect_to root_path, notice: 'Access denied' unless session[:switched_user]
    user = User.where(:extra_admin => true).first
    sign_out(current_user)
    sign_in(:user, user)
    session[:switched_user] = false
    redirect_to "/users/console", notice: 'You are accessing app as admin'
  end
  
  def lock_company
    @company = Company.find(params[:id])
    lock = !@company.is_lock
    
    if current_user.extra_admin?
      @company.update_attributes(:is_lock => lock)
    end
    
    redirect_to :back
  end
  
  def plan
    @plan = DefaultPlan.find(params[:id])
    @plan.update_attributes(params[:name] => params[:value])
    render :nothing => true
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end
  
  def check_pass
    user = User.find(params[:id])
     #if user && user.valid_password?(params[:password])
     #   render :text => "OK"
     #else
    #   render :text => "FALSE"
    # end
    render :text => "AAAAA"
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  
  def update

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to :back, notice: 'User was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end
  
  def destroy_company
    @company = Company.find(params[:id])
    user = User.find(params[:user_id])
     if user && user.valid_password?(params[:password])
       @company.destroy
       redirect_to :back, notice: 'Company was successfully deleted.'
     else
       redirect_to :back, alert: 'Please enter correct password.'
     end
  end
  
  def upgrade
    current_user.upgrade_stripe params[:user][:stripe_card_token], params[:user][:company_plan], params[:user][:card_four]
    redirect_to :back, :notice => "Thank you for subscribing!"
  end
  
  def company_switch_plan
    plan = !@global_company.switch_plan?
    @global_company.update_attributes(:switch_plan => plan)
    redirect_to :back
  end
  
  def console
    if current_user.extra_admin?
      @companies = Company.all
    else
      redirect_to "/"
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  private
  def find_user
    @user = User.find[:id]
  end
end
