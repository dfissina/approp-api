class RenameHashColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :account_hashes, :hash, :hashcode
  end
end
