class AddCounterToDoc < ActiveRecord::Migration
  def change
    add_column :docs, :counter, :integer, :default => 1
  end
end
