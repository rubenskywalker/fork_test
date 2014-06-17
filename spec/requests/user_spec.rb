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
 
 

describe "Users" do

  describe "the signin register company add trial process", :type => :feature do
   
    it "signs me in" do
      
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
      @user = User.make!(:email => 'test@test.com', :password => '111111', :password_confirmation => '111111', :first_name => "Test", :last_name => "Test")
      visit new_user_session_path
      fill_in 'user_email', :with => 'test@test.com'
      fill_in 'user_password', :with => '111111'
      click_on 'Sign in'
      
      page.should have_content('Dashboard')
      
    end
     
    
    
    
  end
  
  

end


