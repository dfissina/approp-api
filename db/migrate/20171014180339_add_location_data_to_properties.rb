class AddLocationDataToProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :street, :string
    add_column :properties, :number, :integer
    add_column :properties, :departament, :integer
    add_column :properties, :tower, :string
    add_column :properties, :neighborhood, :string
    add_column :properties, :show_pin_map, :boolean
    add_reference :properties, :comuna, foreign_key: true
  end
end
