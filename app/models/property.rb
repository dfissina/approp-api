class Property < ApplicationRecord
  belongs_to :user
  
  belongs_to :comuna
  
  enum property_type: [:casa, :departamento]
  
  enum operation: [:venta, :arriendo]
    
  enum state: [:nueva, :usada]
    
  enum currency: [:uf, :clp]
    
  enum orientation: [:norte, :sur, :oriente, :poniente, :norte_sur, :nororiente, :norponiente, :suroriente, :surponiente, :oriente_poniente, :todas]
     
  validates_presence_of :title, :description, :bedrooms, :bathrooms, :price, :build_mtrs,
                        :property_type, :operation, :state, :currency, :street, :number, :show_pin_map,
                        :condominium, :furniture, :orientation, :pets, :lat, :lng
end
