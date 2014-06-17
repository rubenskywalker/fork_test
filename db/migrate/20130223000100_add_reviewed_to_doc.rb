class AddReviewedToDoc < ActiveRecord::Migration
  def change
    add_column :docs, :review, :boolean
  end
end
