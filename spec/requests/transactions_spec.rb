require 'spec_helper'
require 'test_integration_helper'

def sign_in_as(user, password)
  DefaultPlan.blueprint do
    plan_name {"Trial"}
  end
  
  Company.blueprint do
    name { "Test" }
    created_at { Time.now }
    transactions_included { 0 }
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
 
 

describe "Transactions" do

  describe "add transaction and check process", :type => :feature do
   
     
    it "new transaction" do
      sign_in_as('test@test.com', '111111')
      
      visit new_transaction_path
      page.should have_content('New Transaction')
    end
    
    it "create transaction wirhout required" do
      
      Transaction.blueprint do
        mls  { "test" }
      end
      
      sign_in_as('test@test.com', '111111')
      
      visit new_transaction_path
      fill_in 'transaction_address_1', :with => "TEST"
      click_on 'Save'
      page.should have_content('Please fill required fields')
    end
    
    it "create transaction with required" do
      
      Transaction.blueprint do
        mls  { "test" }
      end
      
      sign_in_as('test@test.com', '111111')
      
      visit new_transaction_path
      fill_in 'transaction_address_1', :with => "TEST"
      fill_in 'transaction_location', :with => "Main Office"
      fill_in 'transaction_self_role', :with => "1"
      click_on 'Save'
      page.should have_content('Transaction was successfully created.')
    end
    
    it "edit transaction with required" do
      
      Transaction.blueprint do
        mls  { "test mls name" }
      end
      transaction = Transaction.make!
      
      sign_in_as('test@test.com', '111111')
      
      visit transaction_path(transaction)
      
      page.should have_content('test mls name')
    end
    
    
  end
  
  

end


