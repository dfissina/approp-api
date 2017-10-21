class PropertyResultSearchSerializer < ActiveModel::Serializer
  attributes(*Property.attribute_names.map(&:to_sym))
  attributes :likes
  belongs_to :comuna
  belongs_to :user
  has_many :likes
  has_many :dislikes
  has_many :favourites
   
   def comuna
     {:name => object.comuna.name, :lat => object.comuna.lat, :lng => object.comuna.lng}
   end
   
   def user
       {:first_name => object.user.first_name, :last_name => object.user.last_name, :email => object.user.email}
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



end
