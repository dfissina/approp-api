class PropertySerializer < ActiveModel::Serializer
  # response all property attributes
  attributes(*Property.attribute_names.map(&:to_sym))
  # response model association
  #belongs_to :user
  
  belongs_to :comuna

end
