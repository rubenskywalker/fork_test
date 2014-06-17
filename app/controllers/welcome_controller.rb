class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :pricing]
  def index
    if user_signed_in?
      if current_user.extra_admin?
        redirect_to "/users/console"
      elsif current_user.real_guest?
        redirect_to "/transactions"
      else
        @dashboard = Dashboard.first() || Dashboard.create()
      end
    else
      redirect_to "/home"
    end
  end
  
  def search
    @transactions = Transaction.for_search(params[:search])
    @docs = Doc.for_search(params[:search])
  end
  
  
  
  def dashboard
    @dashboard = Dashboard.first()
    @dashboard.update_attributes(transactions_summary: false,  transactions_alosing: false,  transaction_added: false, transactions_past: false, recent_activity: false, listings: false)
    params[:file_ids].each do |id|
      @dashboard.update_attributes("#{id}" => true)
    end
    
    
  end
  
end
