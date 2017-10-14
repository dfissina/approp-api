class LikeSerializer < ActiveModel::Serializer
  # response all property attributes
  attributes(*Like.attribute_names.map(&:to_sym))
 
  belongs_to :property
end
