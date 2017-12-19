class UserDocumentsSerializer < ActiveModel::Serializer
  attributes :documents, :complete
  #has_many :documents
  
  def complete
    (@documents_size * 100) / 4
  end
    
  def documents
    response_documents = []
    documents_by_type = []
    documents = object.documents.order('document_type_id asc')
    current_document = documents.first
    documents.each do |document|
      if current_document.document_type.id != document.document_type_id
        response_documents.push({
          :document_type_id => current_document.document_type.id, 
          :document_type_name => current_document.document_type.name,
          :documents => documents_by_type
        })        
        documents_by_type = []  
        current_document = document
      end
      documents_by_type.push({:id => document.id, :url => document.document.url})
    end
    
    if !documents_by_type.empty?
      response_documents.push({
        :document_type_id => current_document.document_type.id, 
        :document_type_name => current_document.document_type.name, 
        :documents => documents_by_type
      })
    end
    
    @documents_size = response_documents.size
    
    return response_documents
  end
  
  private 
  
  attr_reader :documents_size
  
end
