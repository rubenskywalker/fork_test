class AddCommisionNoteToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :commision_note, :text
  end
end
