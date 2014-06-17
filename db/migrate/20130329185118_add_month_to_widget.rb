class AddMonthToWidget < ActiveRecord::Migration
  def change
    add_column :widgets, :month_name, :string
    add_column :widgets, :closing_in, :integer
  end
end
