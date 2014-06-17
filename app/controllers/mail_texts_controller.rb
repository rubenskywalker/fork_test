class MailTextsController < ApplicationController
  skip_before_filter :authenticate_user!
  def show
    @text = MailText.find(params[:id])
    render :layout => false
  end
  
  
end
