class LikeSerializer < ActiveModel::Serializer
  attributes :id, :property_photos
  belongs_to :property, :serializer => PropertyResultSearchSerializer
  
  
  def property_photos
    photos = []
    object.property.property_photos.each do |property_photo|
      custom_photo = {:id => property_photo.id, :photo => property_photo.photo.url, :order => property_photo.order}
      photos.push(custom_photo)
    end
    property[:property] = object.property
    property[:property_photos] = photos
    return property
    #object.property.property_photos.first.photo.url
  end
end
