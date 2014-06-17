class AddStripeCardTokenToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :stripe_card_token, :string
    add_column :companies, :card_four, :string
  end
end
