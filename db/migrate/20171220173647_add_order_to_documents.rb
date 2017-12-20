class AddOrderToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :order, :integer
  end
end
