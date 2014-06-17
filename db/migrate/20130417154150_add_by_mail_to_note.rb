class AddByMailToNote < ActiveRecord::Migration
  def change
    add_column :notes, :by_mail, :boolean
  end
end
