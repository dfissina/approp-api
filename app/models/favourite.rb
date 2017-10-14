class Favourite < ApplicationRecord
  belongs_to :user
  belongs_to :property
  
  validates_uniqueness_of :property, scope: :user
end
