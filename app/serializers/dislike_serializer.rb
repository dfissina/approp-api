class DislikeSerializer < ActiveModel::Serializer
  # response all property attributes
  attributes(*Dislike.attribute_names.map(&:to_sym))
 
  belongs_to :property
end
