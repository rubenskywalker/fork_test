class AddByMailToDoc < ActiveRecord::Migration
  def change
    add_column :docs, :by_mail, :boolean
  end
end
