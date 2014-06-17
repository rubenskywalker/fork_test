class MailTemplate < ActiveRecord::Base
  attr_accessible :body, :category, :subject, :variables_list
  
  CATEGORIES_LIST = ["New Account Welcome Email", "Invited to Transaction Email", "Invited User Has Joined Transaction", "Closing Soon Email"]

  CATEGORIES_VARIABLES = [["user_name", "verify_email_link"], ["name_invitee", "name_inviter", "link_to_register", "company_name"], ["name_invitee", "name_inviter", "transaction_name", "transaction_link"], ["user_name", "transaction_name", "checklists"]]


  def self.create_tmpls
    MailTemplate::CATEGORIES_LIST.each_with_index do |cl, index|
      @mt = MailTemplate.find_or_create_by_category(cl)
      @mt.update_attributes(:variables_list => MailTemplate::CATEGORIES_VARIABLES[index].join(", "))
    end
    
  end
end
