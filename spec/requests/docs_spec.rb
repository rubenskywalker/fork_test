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
 
 

describe "Docs AND Uploads" do

  it "Upload FILE PDF" do
    
    Doc.blueprint do
      filename  { "new.pdf" }
      alisa  { "new.pdf" }
    end
    cklist.make!
    
    Transaction.blueprint do
      mls  { "test mls name" }
      
    end
    transaction = Transaction.make!
    
    sign_in_as('test@test.com', '111111')
    
    visit transaction_path(transaction)
    click_link_or_button('Upload new document')
    browse "new.pdf"
    click_on 'Submit'
    
    page.should have_content('new.pdf')
  end
  
  it "Upload DUBLICATE FILE PDF" do
    
    Doc.blueprint do
      filename  { "new.pdf" }
      alisa  { "new.pdf" }
    end
    cklist.make!
    
    Transaction.blueprint do
      mls  { "test mls name" }
      
    end
    transaction = Transaction.make!
    
    sign_in_as('test@test.com', '111111')
    
    visit transaction_path(transaction)
    click_link_or_button('Upload new document')
    browse "new.pdf"
    click_on 'Submit'
    
    page.should have_content('new.pdf')
    
    visit transaction_path(transaction)
    click_link_or_button('Upload new document')
    browse "new.pdf"
    click_on 'Submit'
    
    page.should have_content("Duplicate file wasn't uploaded.")
  end
  
  
  it "Upload NON FILE PDF" do
    
    Doc.blueprint do
      filename  { "new.jpg" }
      alisa  { "new.jpg" }
    end
    cklist.make!
    
    Transaction.blueprint do
      mls  { "test mls name" }
      
    end
    
    TransactionDetails.blueprint do
      pdf_only  { true }
      
    end
    transaction = Transaction.make!
    
    sign_in_as('test@test.com', '111111')
    
   
    
    visit transaction_path(transaction)
    click_link_or_button('Upload new document')
    browse "new.jpg"
    click_on 'Submit'
    
    page.should have_content("Non-pdf file wasn't uploaded.")
  end

end


