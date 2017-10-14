class UserSerializer < ActiveModel::Serializer
  # response all user attributes
  attributes(*User.attribute_names.map(&:to_sym))
    
  # response model association
  #has_many :properties
end
