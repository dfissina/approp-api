class AddPasswordToAccountHashes < ActiveRecord::Migration[5.1]
  def change
    add_column :account_hashes, :password, :string
  end
end
