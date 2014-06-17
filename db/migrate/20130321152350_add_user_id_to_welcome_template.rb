class AddUserIdToWelcomeTemplate < ActiveRecord::Migration
  def change
    add_column :welcome_templates, :user_id, :integer
  end
end
