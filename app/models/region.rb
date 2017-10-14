class Region < ApplicationRecord
  
  has_many :comunas
  
  validates_presence_of :name, :lat, :lng
end
