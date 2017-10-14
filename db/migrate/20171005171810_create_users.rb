class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.date :birth_date
      t.string :phone
      t.string :cell_phone

      t.timestamps
    end
  end
end
