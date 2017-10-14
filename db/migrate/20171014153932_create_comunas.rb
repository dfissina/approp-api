class CreateComunas < ActiveRecord::Migration[5.1]
  def change
    create_table :comunas do |t|
      t.string :name
      t.float :lat
      t.float :lng
      t.references :region, foreign_key: true

      t.timestamps
    end
  end
end
