class LocationPermission < ActiveRecord::Base
  attr_accessible :l1, :l2, :l3, :l4, :l5, :l6, :l7, :l8, :l9, :l10, :l11, :l12, :l13, :l14, :l15, :l16, :l17, :l18, :location_id, :user_id
  belongs_to :user
  belongs_to :location
  
  scope :for_notes, where(:l7 => true)
  default_scope order('locations.name ASC').includes(:location)
  
end
