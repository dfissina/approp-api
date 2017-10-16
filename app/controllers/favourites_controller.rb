class FavouritesController < ApplicationController

  swagger_controller :favourites, 'Favourites Managment'

  # GET /favourites
  def index
   json_response(current_user.favourites)
  end
 
  # GET /favourites/:id
  def show
   @favourite = Favourite.find(params[:id])
   json_response(@favourite)
  end
   
  # POST /favourites
  def create
   property = Property.find(params[:property_id])
   current_user.favourites.create!(property_id: property.id) 
   json_response(current_user.favourites, :created)
  end
  
  # DELETE /favourites/:id
  def destroy
   @favourite = Favourite.find(params[:id])
   @favourite.destroy
   head :no_content
  end

  swagger_api :index do
    summary 'Show  all favourites'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  swagger_api :show do
    summary 'Show  favourite'
    param :path, :id, :integer, :required, 'Favourite id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  swagger_api :create do
    summary 'Create favourite'
    param :form, :property_id, :integer, :required, 'Property id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  swagger_api :destroy do
    summary 'Delete favourite'
    param :path, :id, :integer, :required, 'Like id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end
  
end
