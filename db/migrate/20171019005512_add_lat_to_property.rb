class AddLatToProperty < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :lat, :float
  end
end
