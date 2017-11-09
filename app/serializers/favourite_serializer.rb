class FavouriteSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :property
      
  def property
    photos = []
    object.property.property_photos.each do |property_photo|
      custom_photo = {:id => property_photo.id, :photo => property_photo.photo.url, :order => property_photo.order}
      photos.push(custom_photo)
    end
    
    {
      :id => object.property.id, 
      :title => object.property.title,
      :description => object.property.description,
      :bedrooms => object.property.bedrooms,
      :bathrooms => object.property.bathrooms,
      :price => object.property.price,
      :build_mtrs => object.property.build_mtrs,
      :total_mtrs => object.property.total_mtrs,
      :property_type => object.property.property_type,
      :operation => object.property.operation,
      :state => object.property.state,
      :currency => object.property.currency,
      :street => object.property.street,
      :number => object.property.number,
      :departament => object.property.departament,
      :tower => object.property.tower,
      :neighborhood => object.property.neighborhood,
      :show_pin_map => object.property.show_pin_map,
      :condominium => object.property.condominium,
      :furniture => object.property.furniture,
      :orientation => object.property.orientation,
      :parking_lots => object.property.parking_lots,
      :cellar => object.property.cellar,
      :expenses => object.property.expenses,
      :pets => object.property.pets,
      :terrace => object.property.terrace,
      :lat => object.property.lat,
      :lng => object.property.lng,
      :cod => object.property.cod,
      :views => object.property.views,
      :likes => object.property.likes.size,
      :dislikes => object.property.dislikes.size,
      :favourites => object.property.favourites.size,
      :comuna => {:name => object.property.comuna.name, :lat => object.property.comuna.lat, :lng => object.property.comuna.lng},
      :user => {:first_name => object.property.user.first_name, :last_name => object.property.user.last_name, :email => object.property.user.email, :phone => object.property.user.phone},
      :property_photos => photos
    }      
  end

end
