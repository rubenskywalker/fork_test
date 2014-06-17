class CreateWelcomeTemplates < ActiveRecord::Migration
  def change
    create_table :welcome_templates do |t|
      t.string :name
      t.string :subject
      t.text :message

      t.timestamps
    end
  end
end
