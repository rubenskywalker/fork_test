class AddMyselfToWidget < ActiveRecord::Migration
  def change
    add_column :widgets, :myself, :boolean, :default => false
  end
end
