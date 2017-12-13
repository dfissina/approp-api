class AddFacebookAccountAndLastLoginToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :facebook_account, :boolean
    add_column :users, :last_login, :datetime
  end
end
