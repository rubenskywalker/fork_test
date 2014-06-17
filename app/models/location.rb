class Location < ActiveRecord::Base
  attr_accessible :name, :company_id
  has_many :transactions
  has_many :location_permissions, :dependent => :destroy
  has_many :widgets, :dependent => :destroy
  belongs_to :company
  
  after_create :setup_permissions
  scope :for_user, lambda { |user| where("location_permissions.user_id = ? and (location_permissions.l12 = ? OR location_permissions.l2 = ? OR location_permissions.l1 = ?)", user.id, true, true, true).includes(:location_permissions)}
  scope :for_notes, where("location_permissions.l7 = ?", true).includes(:location_permissions)
  
  default_scope order('locations.name ASC')
  def self.for_current user
    if user.super_admin? || user.p_all?
      Location.all
    else
      Location.for_user(user)
    end
  end
  private
  def setup_permissions
    User.where(:company_id => self.company_id).each do |user|
      self.location_permissions.create(:user_id => user.id)
    end
  end
end
