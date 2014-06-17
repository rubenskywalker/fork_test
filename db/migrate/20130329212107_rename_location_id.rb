class RenameLocationId < ActiveRecord::Migration
  def up
    #rename_column :transactions, :location_id, :location_id_old
    #add_column :transactions, :location_id, :integer

    #Transaction.reset_column_information
    #Transaction.find_each { |c| c.update_attribute(:location_id, c.location_id_old.to_i) } 
    #remove_column :transactions, :location_id_old
  end

end
