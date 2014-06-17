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
 
 

describe "Local Permissions" do

  describe "Chech Ability", :type => :feature do
   
     
    
    
    it "user to UserPermission required" do
      
      UserPermission.blueprint do
        l1 {true}
        l2 {true}
        l3 {true}
        l4 {true}
        l5 {true}
        l6 {true}
        l7 {true}
        l8 {true}
        l9 {true}
        l10 {true}
        l11 {true}
        l12 {true}
      end
      
      User.blueprint do
        email  { "test@test.com" }
        company { Company.make! }
        user_permissions {UserPermission.make! }
      end
      
      Location.blueprint do
        name  { "Main Office" }
        user { User.make!}
        user_permissions {UserPermission.make! }
      end
      
      
    end
    
    
    
  end
  
  

end


