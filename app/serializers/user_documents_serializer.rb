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
    current_document_type = documents.first.document_type_id  
    documents.each do |document|
      if current_document_type != document.document_type_id
        response_documents.push({:type_id => current_document_type, :documents => documents_by_type})
        documents_by_type = []  
        current_document_type = document.document_type_id
      end
      documents_by_type.push({:url => document.document.url})
    end
    
    if !documents_by_type.empty?
      response_documents.push({:type_id => current_document_type, :documents => documents_by_type})
    end
    
    @documents_size = response_documents.size
    
    return response_documents
  end
  
  private 
  
  attr_reader :documents_size
  
end
