class Comuna < ApplicationRecord
  belongs_to :region
  
  has_many :properties
    
  validates_presence_of :name, :lat, :lng
end
