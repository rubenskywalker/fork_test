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
 
 

describe "Dashboard" do

  describe "should have default widgets", :type => :feature do
    
    sign_in_as('test@test.com', '111111')
    visit "/"
    page.should have_content("Transactions Summary")
    page.should have_content("Transactions Past Their Closing Date")
    page.should have_content("Transactions Closing In The Next 30 Days")
    page.should have_content("Transactions Added In The Past 30 Days")
    page.should have_content("Listings")
    page.should have_content("Recent Activity")
      
  end
  
  describe "should be draggable", :type => :feature do
    
    sign_in_as('test@test.com', '111111')
    visit "/"
    page.should have_content("draggable")
    
      
  end
    
end



