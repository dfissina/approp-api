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
  
  has_many :documents
  
  has_many :message_contacts
  
  enum rol: [:customer, :agent, :admin]
  #validates :rol, :email, presence: true
    
  enum user_type: [:independiente, :dependiente, :null]
    
  mount_uploader :profile_picture, ProfilePictureUploader
  
  validates :profile_picture, file_size: { less_than_or_equal_to: 1.megabytes, message: 'El tamaño de su foto de perfil debe ser menor a 1 megabyte.'  },
                              file_content_type: { allow: ['image/jpeg', 'image/png'], message: 'La foto de perfil deber ser JPG o PNG.'  }
  
  # Validations
  validates_presence_of :first_name, :last_name, :email, :password_digest, :birth_date, :rol
  
  #private
  
  def self.generate_password
    SecureRandom.hex(10)
  end
end
