class AddCodigoToProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :cod, :string
  end
end
