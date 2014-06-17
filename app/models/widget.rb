class Widget < ActiveRecord::Base
  attr_accessible :dashboard_id, :location_id, :widget_date, :widget_type, :month_name, :user_id, :closing_in, :position, :ra_for, :myself
  belongs_to :location
  belongs_to :dashboard
  belongs_to :user
  TYPES = [["Transactions Summary by Category", "transactions_summary"],
           ["Transactions Summary Grid", "transactions_summary_grid"],
           ["Transactions Past Their Closing Date", "transactions_past"],
           ["Transactions Closing In The Next 30 Days", "transactions_alosing"],
           ["Transactions Added In The Past 30 Days", "transaction_added"],
           ["Listings", "listings"], 
           ["Recent Activity", "recent_activity"],
           ["Transactions With Unreviewed Documents", "unreviewed_documents"]
          ]
  MONTH = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
  
  default_scope order('position ASC')
  
  after_create :add_position
  after_create :add_location_or_myself
  
  def ra_for_array locations
    ra = []
    ra << ["All Locations", 0]
    locations.each do |l|
      ra << ["#{l.name}", l.id]
    end
    ra << ["Myself", "myself"]
    ra
  end
  
  def locations_list
    (self.user.super_admin? || self.user.p_all?) ? Location.where(:company_id => self.user.company_id).map(&:id) : Location.where(:company_id => self.user.company_id).for_user(self.user).map(&:id)
  end
  
  def transactions_list
    t = self.myself? ? Transaction.where(:user_id => self.user_id) : (self.location_id == 0 ? Transaction.where(:location_id => self.locations_list) : Transaction.where(:location_id => self.location_id))
    case self.widget_type
      when "transactions_summary"
        t
      when "transactions_summary_grid"
        t
      when "transactions_past"
        t.widget_transactions_past
      when "transactions_alosing"
        t.widget_transactions_alosing
      when "transaction_added"
        t.widget_transaction_added
      when "unreviewed_documents"
        t.widget_unreviewed_documents
      when "listings"
        t.widget_listing
    end
  end
  
  def self.sort_positions!(ids)
    ids.each_with_index do |id, index|
      Widget.find(id).update_attributes(position: index + 1)
    end
  end
  
  private
  
  def add_location_or_myself
    if self.location.nil? && self.location_id != 0
      self.update_attributes(:myself => true)
    end
  end
  
  def add_position
    case self.widget_type
      when "transactions_summary"
        self.update_attributes(:position => 1)
      when "transactions_past"
        self.update_attributes(:position => 2)
      when "transactions_alosing"
        self.update_attributes(:position => 3)
      when "transaction_added"
        self.update_attributes(:position => 4)
      when "listings"
        self.update_attributes(:position => 5)
      when "recent_activity"
        self.update_attributes(:position => 6)
      when "unreviewed_documents"
        self.update_attributes(:position => 7)
      when "transactions_summary_grid"
        self.update_attributes(:position => 8)
    end
  end
end
