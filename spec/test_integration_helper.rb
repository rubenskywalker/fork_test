require "spec_helper"

module ActionController
  class IntegrationTest
    include Capybara

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
       user.confirmed_at = Time.now 
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
  end
end