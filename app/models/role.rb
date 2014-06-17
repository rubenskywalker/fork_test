class Role < ActiveRecord::Base
  attr_accessible :name, :user_id, :sorting
  has_many :users
  has_many :contacts
  has_many :attach_contacts
  
  default_scope order('sorting ASC')
end
