class ChangeTypeColumnToDocumentTypes < ActiveRecord::Migration[5.1]
  def change
    rename_column :document_types, :type, :document_type
  end
end
