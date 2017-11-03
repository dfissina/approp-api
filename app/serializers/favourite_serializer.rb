class FavouriteSerializer < ActiveModel::Serializer
  # response all property attributes
  attributes(*Favourite.attribute_names.map(&:to_sym))
 
  belongs_to :property
  belongs_to :user

  def property
    object.property
  end

  def user
    object.user
  end
end
