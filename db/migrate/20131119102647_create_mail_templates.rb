class CreateMailTemplates < ActiveRecord::Migration
  def change
    create_table :mail_templates do |t|
      t.text :category
      t.text :body
      t.string :subject
      t.text :variables_list

      t.timestamps
    end
  end
end
