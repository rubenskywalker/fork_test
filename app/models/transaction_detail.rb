class TransactionDetail < ActiveRecord::Base
  attr_accessible :company_id, :address_1, :address_2, :ba_commision, :city, :acceptance_date, :county, :close_date, :commision_note, :expiration_date, :l1, :l1n, :la_commision, :list_price, :sale_price, :what_role, :mls, :state, :transaction_format, :zip, :offer, :pending, :listing, :auto_lock, :t_status, :t_type, :only_pdf
  has_many :transaction_types
  has_many :transaction_statuses
  belongs_to :company
  
  after_create :add_defaults
  
  
  private
  def add_defaults
    self.update_attributes(:l1n => 1, 
                           :what_role => 1,
                           :t_status => 0,
                           :t_type => 0, 
                           :address_1 => 0, 
                           :address_2 => 0, 
                           :city => 0,
                           :state => 0,
                           :zip => 0,
                           :mls => 0,
                           :close_date => 0,
                           :expiration_date => 0,
                           :list_price => 0,
                           :sale_price => 0,
                           :ba_commision => 0,
                           :la_commision => 0,
                           :commision_note => 0,
                           :acceptance_date => 0,
                           :county => 0
                           )
  end
end
