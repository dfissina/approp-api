class CreateProperties < ActiveRecord::Migration[5.1]
  def change
    create_table :properties do |t|
      t.string :title
      t.text :description
      t.integer :bedrooms
      t.integer :bathrooms
      t.decimal :price
      t.integer :build_mtrs
      t.integer :total_mtrs
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
