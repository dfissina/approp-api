class FavouriteSerializer < ActiveModel::Serializer
  # response all property attributes
  attributes(*Favourite.attribute_names.map(&:to_sym))
 
  belongs_to :property
end
