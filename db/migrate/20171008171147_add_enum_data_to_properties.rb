class AddEnumDataToProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :property_type, :integer
    add_column :properties, :operation, :integer
    add_column :properties, :state, :integer
    add_column :properties, :currency, :integer
  end
end
