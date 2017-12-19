class CreateDocumentTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :document_types do |t|
      t.integer :type
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
