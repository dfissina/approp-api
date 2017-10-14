class Property < ApplicationRecord
  belongs_to :user
  
  enum property_type: [:casa, :departamento]
  
  enum operation: [:venta, :arriendo]
    
  enum state: [:nueva, :usada]
    
  enum currency: [:uf, :clp]
    
  belongs_to :user
    
  validates_presence_of :title, :description, :bedrooms, :bathrooms, :price, :build_mtrs, :total_mtrs,
                        :property_type, :operation, :state, :currency  

end
