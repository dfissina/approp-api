class FavouriteSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :property, :serializer => PropertyResultSearchSerializer

end
