class PropertySerializer < ActiveModel::Serializer
  attributes(*Property.attribute_names.map(&:to_sym))
     
  #belongs_to :comuna
  #belongs_to :user

  #def comuna
  #  {:name => object.comuna.name, :lat => object.comuna.lat, :lng => object.comuna.lng}
  #end
     
  #def user
  #  {:first_name => object.user.first_name, :last_name => object.user.last_name, :email => object.user.email}
  #end

end
