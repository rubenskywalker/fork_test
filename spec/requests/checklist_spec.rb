require 'spec_helper'
require 'test_integration_helper'

def sign_in_as(user, password)
  DefaultPlan.blueprint do
    plan_name {"Trial"}
  end
  
  Company.blueprint do
    name { "Test" }
    plan_name { "Trial" }
  end
  User.blueprint do
    email  { "test@test.com" }
    company { Company.make! }
  end
  DefaultPlan.make!
   user = User.make!(:email => user, :password => password, :password_confirmation => password, :first_name => "Test", :last_name => "Test")
   user.save!
   visit new_user_session_path
   fill_in 'user_email', :with => user.email
   fill_in 'user_password', :with => password
   click_link_or_button('Sign in')
   user      
 end 
 def sign_out
    click_link_or_button('Sign Out')   
 end
 
 

describe "Chacklist" do

  it "view checklist" do
    
    Checklist.blueprint do
      name  { "NEW TEST CEHCKLIST" }
    end
    checklist = Checklist.make!
    
    Transaction.blueprint do
      mls  { "test mls name" }
      checklist { Checklist.make! }
    end
    transaction = Transaction.make!
    
    sign_in_as('test@test.com', '111111')
    
    visit transaction_path(transaction)
    
    page.should have_content('NEW TEST CEHCKLIST')
  end
  

end


