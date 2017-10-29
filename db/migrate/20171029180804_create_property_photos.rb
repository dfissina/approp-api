class CreatePropertyPhotos < ActiveRecord::Migration[5.1]
  def change
    create_table :property_photos do |t|
      t.text :photo
      t.integer :order
      t.references :property, foreign_key: true

      t.timestamps
    end
  end
end
