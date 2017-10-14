class User < ApplicationRecord
  # encrypt password
  has_secure_password
  
  # Model associations
  has_many :properties 
  
  has_many :likes
  has_many :liked_properties, through: :likes
  
  has_many :dislikes
  has_many :disliked_properties, through: :dislikes
  
  has_many :favourites
  has_many :favourites_properties, through: :favourites
  
  #has_many :favorites
  #has_many :favorited_properties, through: :favorites
  #has_many :likes
  #has_many :liked_properties, through: :likes
  #has_many :dislikes
  #has_many :disliked_properties, through: :dislikes

  #validates :rol, :email, presence: true
  
  # Validations
  validates_presence_of :first_name, :last_name, :email, :password_digest, :birth_date
end
