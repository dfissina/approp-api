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
  
  # Validations
  validates_presence_of :first_name, :last_name, :email, :password_digest, :birth_date, :rol

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
