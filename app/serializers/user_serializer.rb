class UserSerializer < ActiveModel::Serializer
  
  attributes :id, :first_name, :last_name, :email, :phone, :cell_phone, :profile_picture
  
  def profile_picture
    object.profile_picture.url
  end
  
end  
  
