class CreateMessageContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :message_contacts do |t|
      t.text :message
      t.string :name
      t.string :email
      t.string :phone
      t.references :sender_user, foreign_key: { to_table: :users }
      t.references :property, foreign_key: true

      t.timestamps
    end
  end
end
