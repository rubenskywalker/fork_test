class CreateMailTexts < ActiveRecord::Migration
  def change
    create_table :mail_texts do |t|
      t.text :content

      t.timestamps
    end
  end
end
