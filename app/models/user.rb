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
  
  enum rol: [:customer, :agent, :admin]
  #validates :rol, :email, presence: true
    
  mount_uploader :profile_picture, ProfilePictureUploader
  
  validates :profile_picture, file_size: { less_than_or_equal_to: 1.megabytes, message: 'El tamaño de su foto de perfil debe ser menor a 1 megabyte.'  },
                              file_content_type: { allow: ['image/jpeg', 'image/png'], message: 'La foto de perfil deber ser JPG o PNG.'  }
  
  # Validations
  validates_presence_of :first_name, :last_name, :email, :password_digest, :birth_date, :rol

  def activate_account!
    self.account_active = true
    save!
  end

  def generate_password_token!
    self.password = generate_password
    self.password_reseted = true
    save!
  end

  private

  def generate_password
    SecureRandom.hex(10)
  end
end
