class MailTemplatesController < ApplicationController
  
  def edit
    @mail_template = MailTemplate.find(params[:id])
  end
  
  def update
    @mail_template = MailTemplate.find(params[:id])
    @mail_template.update_attributes(params[:mail_template])
    
    redirect_to "/users/console"
  end
  
  
  def test_mail
    @mail_template = MailTemplate.find(params[:mail_template])
    
    case @mail_template.category
      when MailTemplate::CATEGORIES_LIST[0]
        DefaultMailer.welcome(current_user, params[:mail]).deliver
      when MailTemplate::CATEGORIES_LIST[1]
        DefaultMailer.invitation_mail(current_user, CompanyInvite.last, params[:mail]).deliver
      when MailTemplate::CATEGORIES_LIST[2]
        ""
      when MailTemplate::CATEGORIES_LIST[3]
        DefaultMailer.transaction_closing_soon(current_user.transactions.last, params[:mail]).deliver
    end
    
    redirect_to "/users/console"
    
  end
end
