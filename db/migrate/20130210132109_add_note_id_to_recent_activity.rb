class AddNoteIdToRecentActivity < ActiveRecord::Migration
  def change
    add_column :recent_activities, :note_id, :integer
  end
end
