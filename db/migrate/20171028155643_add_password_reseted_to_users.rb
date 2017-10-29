class AddPasswordResetedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :password_reseted, :boolean
  end
end
