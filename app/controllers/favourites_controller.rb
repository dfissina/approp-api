class FavouritesController < ApplicationController

  swagger_controller :favourites, 'Favourites Managment'

  swagger_api :index do
    summary 'Show  all favourites'
    param :query, :page, :integer, :optional, 'Page'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  # GET /favourites
  def index
    if params[:page].present?
      page = params[:page]
    else
      page = 1
    end
    @favourites =  current_user.favourites.order('created_at ASC')
    favs_size = @favourites.size
    @favourites = @favourites.paginate(:page => page, :per_page => 10)
    render json: {
        favourites: ActiveModel::Serializer::CollectionSerializer.new(@favourites, serializer: FavouriteSerializer),
        total_size: favs_size,
        total_pages: @favourites.total_pages
    }
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
    summary 'Delete favourite by property id'
    param :path, :property_id, :integer, :required, 'Property id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end
  
  # DELETE /favourites/:property_id
  def destroy
    @favourite = Favourite.where(:property_id => params[:property_id]).where(:user_id => current_user.id).first
    @favourite.destroy
    head :no_content
  end

  swagger_api :getAllFavouritesIds do
    summary 'All properties favourite ids'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  # GET /favourites/ids
  def getAllFavouritesIds
    favourites = []
    current_user.favourites.each do |favourite|
      favourites.push(favourite.property_id)
    end
    render json: {
        favourites_properties_ids: favourites
    }
  end

end
