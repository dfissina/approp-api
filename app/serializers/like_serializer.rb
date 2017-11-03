class LikeSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :property, :serializer => PropertyResultSearchSerializer
  
end
