class AddLatToProperty < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :lat, :float, :precision => 15, :scale => 8
  end
end
