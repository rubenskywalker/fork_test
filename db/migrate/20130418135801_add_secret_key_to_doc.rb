class AddSecretKeyToDoc < ActiveRecord::Migration
  def change
    add_column :docs, :secret_key, :string
  end
end
