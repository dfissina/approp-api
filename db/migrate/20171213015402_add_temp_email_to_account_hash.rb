class AddTempEmailToAccountHash < ActiveRecord::Migration[5.1]
  def change
    add_column :account_hashes, :temp_email, :string
  end
end
