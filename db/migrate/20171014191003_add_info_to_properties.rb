class AddInfoToProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :condominium, :boolean
    add_column :properties, :furniture, :boolean
    add_column :properties, :orientation, :integer
    add_column :properties, :parking_lots, :integer
    add_column :properties, :cellar, :integer
    add_column :properties, :expenses, :decimal
    add_column :properties, :pets, :boolean
    add_column :properties, :terrace, :boolean
  end
end
