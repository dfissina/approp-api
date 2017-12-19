class ChangeSenderUserColumnToMessageContacts < ActiveRecord::Migration[5.1]
  def change
    rename_column :message_contacts, :sender_user_id, :user_id
  end
end
