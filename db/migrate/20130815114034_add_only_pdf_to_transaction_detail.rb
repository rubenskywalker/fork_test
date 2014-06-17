class AddOnlyPdfToTransactionDetail < ActiveRecord::Migration
  def change
    add_column :transaction_details, :only_pdf, :boolean, :default => false
  end
end
