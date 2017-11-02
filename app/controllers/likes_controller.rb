class LikesController < ApplicationController

  swagger_controller :likes, 'Likes Managment'

  swagger_api :index do
    summary 'Show  all likes'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end
  
  # GET /likes
  def index
    json_response(current_user.likes)
  end

  swagger_api :show do
    summary 'Show  like'
    param :path, :id, :integer, :required, 'Like id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end
 
  # GET /likes/:id
  def show
   @like = Like.find(params[:id])
   json_response(@like)
  end

  swagger_api :create do
    summary 'Create  like'
    param :form, :property_id, :integer, :required, 'Property id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end
   
  # POST /likes
  def create
   property = Property.find(params[:property_id])
   current_user.likes.create!(property_id: property.id) 
   json_response(current_user.likes, :created)
  end

  swagger_api :destroy do
    summary 'Delete like'
    param :path, :id, :integer, :required, 'Like id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end
  
  # DELETE /likes/:property_id
  def destroy
   ########
   # Borrar Like por property_id y current_user
   ########
   @like = Like.find(params[:id])
   @like.destroy
   head :no_content
  end

  swagger_api :getAllLikesIds do
    summary 'All properties liked ids'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  #GET /likes/ids
  def getAllLikesIds
    likes = []
    current_user.likes.each do |like|
      likes.push(like.property_id)
    end
    render json: {
        likes_properties_ids: likes
    }
  end

end
