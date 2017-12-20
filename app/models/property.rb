class Property < ApplicationRecord

  acts_as_mappable :lat_column_name => :lat,
                   :lng_column_name => :lng

  belongs_to :user
  
  belongs_to :comuna
  
  has_many :likes
  
  has_many :dislikes
  
  has_many :favourites
  
  has_many :property_photos, dependent: :destroy
  
  enum property_type: [:casa, :departamento, :parcela, :terreno]
  
  enum operation: [:venta, :arriendo]
    
  enum state: [:nueva, :usada]
    
  enum currency: [:uf, :clp]
    
  enum orientation: [:norte, :sur, :oriente, :poniente, :norte_sur, :nororiente, :norponiente, :suroriente, :surponiente, :oriente_poniente, :todas]
     
  validates_presence_of :title, :description, :bedrooms, :bathrooms, :price, :build_mtrs,
                        :property_type, :operation, :state, :currency, :street, :number, :show_pin_map,
                        :orientation, :lat, :lng
end
