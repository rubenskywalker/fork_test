class ApplicationController < ActionController::Base
  protect_from_forgery
  
  
  before_filter :authenticate_user!
  before_filter :set_global_company
  
  def login_user
    unless user_signed_in?
     @user = User.find_by_email("s@s.com")
     sign_in @user
   end
  end
  
  def global_admin_access
    unless user_signed_in? && (current_user.super_admin? && !@global_company.real_free?)
      redirect_to "/"
    end
  end
  
  def set_global_company
    if user_signed_in?
      @global_company = current_user.company
      
      if (@global_company.trial_ended? || @global_company.disabled?) && !current_user.extra_admin?
        redirect_to "/profile" unless session[:switched_user] || params[:action] == "profile" || params[:action] == "upgrade" || params[:controller].include?("devise")
      end
      
    end 
  end
  
  def current_ability
    @current_ability ||= Ability.new(current_user, @global_company)
  end
  
  def not_found
    raise ActiveRecord::RecordNotFound.new('Not Found')
  end
  
  protected
  
  
  
end
