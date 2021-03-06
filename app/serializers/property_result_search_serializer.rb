class PropertyResultSearchSerializer < ActiveModel::Serializer
  # Excluir de la respuesta de propiedad: user_id, created_at, updated_at, comuna_id
  attributes(*Property.attribute_names.map(&:to_sym))
  attributes :likes
  belongs_to :comuna
  belongs_to :user
  has_many :likes
  has_many :dislikes
  has_many :favourites
  has_many :property_photos
   
  def comuna
    {:name => object.comuna.name, :lat => object.comuna.lat, :lng => object.comuna.lng}
  end
 
  def user
    {:first_name => object.user.first_name, :last_name => object.user.last_name, :email => object.user.email, :phone => object.user.phone}
  end
 
  def likes
    object.likes.size
  end
 
  def dislikes
    object.dislikes.size
  end
   
  def favourites
    object.favourites.size
  end
  
  def property_photos
    photos = []
    object.property_photos.each do |property_photo|
      custom_photo = {:id => property_photo.id, :photo => property_photo.photo.url, :order => property_photo.order}
      photos.push(custom_photo)
    end
    return photos
  end
  
end
