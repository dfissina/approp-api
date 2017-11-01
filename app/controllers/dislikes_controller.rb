class DislikesController < ApplicationController

  swagger_controller :dislike, 'Dislikes Managment'

  swagger_api :index do
    summary 'Show  all likes'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end
  
  # GET /dislikes
  def index
   json_response(current_user.dislikes)
  end

  swagger_api :show do
    summary 'Show  dislike'
    param :path, :id, :integer, :required, 'Dislike id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end
 
  # GET /dislikes/:id
  def show
   @dislike = Dislike.find(params[:id])
   json_response(@dislike)
  end

  swagger_api :create do
    summary 'Create dislikes'
    param :form, :property_id, :integer, :required, 'Property id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end
   
  # POST /dislikes
  def create
   property = Property.find(params[:property_id])
   current_user.dislikes.create!(property_id: property.id) 
   json_response(current_user.dislikes, :created)
  end

  swagger_api :destroy do
    summary 'Delete dislike'
    param :path, :id, :integer, :required, 'Like id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end
  
  # DELETE /dislikes/:id
  def destroy
   @dislike = Dislike.find(params[:id])
   @dislike.destroy
   head :no_content
  end

  swagger_api :getAllDislikesIds do
    summary 'All properties disliked ids'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  #GET /dislikesids
  def getAllDislikesIds
    dislikes = []
    current_user.dislikes.each do |dislike|
      dislikes.push(dislike.property_id)
    end
    render json: {
        dislikes_properties_ids: dislikes
    }
  end

  swagger_api :deleteByPropId do
    summary 'Delete dislike by property id'
    param :path, :property_id, :integer, :required, 'Property id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  #GET /dislike/:property_id
  def deleteByPropId
    @dislike = Dislike.find_by_property_id(params[:property_id])
    if !@dislike.nil?
      @dislike.destroy
      head :no_content
    else
      render json: { msg: 'Dislike not found' }
    end
  end
end
