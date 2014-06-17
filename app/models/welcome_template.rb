class WelcomeTemplate < ActiveRecord::Base
  attr_accessible :message, :name, :subject, :user_id
end
