class PropertiesController < ApplicationController
  before_action :set_user
  before_action :set_user_property, only: [:show, :update, :destroy]
  
  # GET /user/:user_id/properties
  def index
   json_response(@user.properties)
  end
 
  # GET /user/:user_id/properties/:id
  def show
   json_response(@property)
  end
   
  # POST /users/:user_id/properties
  def create
   @user.properties.create!(property_params)
   json_response(@user.properties.last, :created)
  end
 
  # PUT /users/:user_id/properties/:id
  def update
   @property.update(property_params)
   head :no_content
  end
   
  # DELETE /users/:user_id/properties/:id
  def destroy
   @property.destroy
   head :no_content
  end


  private  

  def set_user
    @user = User.find(params[:user_id])
  end
    
  def set_user_property    
    @property = @user.properties.find_by!(id: params[:id]) if @user
  end
  
  def property_params
    # whitelist params
    params.permit(
      :title, 
      :description,
      :bedrooms,
      :bathrooms,
      :price,
      :build_mtrs,
      :total_mtrs,
      :property_type,
      :operation,
      :state,
      :currency      
    )
  end
end
