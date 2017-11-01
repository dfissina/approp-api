class FavouritesController < ApplicationController

  swagger_controller :favourites, 'Favourites Managment'

  swagger_api :index do
    summary 'Show  all favourites'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  # GET /favourites
  def index
   json_response(current_user.favourites)
  end

  swagger_api :show do
    summary 'Show  favourite'
    param :path, :id, :integer, :required, 'Favourite id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end
 
  # GET /favourites/:id
  def show
   @favourite = Favourite.find(params[:id])
   json_response(@favourite)
  end

  swagger_api :create do
    summary 'Create favourite'
    param :form, :property_id, :integer, :required, 'Property id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end
   
  # POST /favourites
  def create
   property = Property.find(params[:property_id])
   current_user.favourites.create!(property_id: property.id) 
   json_response(current_user.favourites, :created)
  end

  swagger_api :destroy do
    summary 'Delete favourite'
    param :path, :id, :integer, :required, 'Like id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end
  
  # DELETE /favourites/:id
  def destroy
   @favourite = Favourite.find(params[:id])
   @favourite.destroy
   head :no_content
  end

  swagger_api :getAllFavouritesIds do
    summary 'All properties favourite ids'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  #GET /favouritesids
  def getAllFavouritesIds
    favourites = []
    current_user.favourites.each do |favourite|
      favourites.push(favourite.property_id)
    end
    render json: {
        favourites_properties_ids: favourites
    }
  end

  swagger_api :deleteByPropId do
    summary 'Delete favourite by property id'
    param :path, :property_id, :integer, :required, 'Property id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  #GET /favourite/:property_id
  def deleteByPropId
    @favourite = Favourite.find_by_property_id(params[:property_id])
    if !@favourite.nil?
      @favourite.destroy
      head :no_content
    else
      render json: { msg: 'Favourite not found' }
    end

  end
end
