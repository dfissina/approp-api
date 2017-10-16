class DislikesController < ApplicationController

  swagger_controller :dislike, 'Dislikes Managment'
  
  # GET /dislikes
  def index
   json_response(current_user.dislikes)
  end
 
  # GET /dislikes/:id
  def show
   @dislike = Dislike.find(params[:id])
   json_response(@dislike)
  end
   
  # POST /dislikes
  def create
   property = Property.find(params[:property_id])
   current_user.dislikes.create!(property_id: property.id) 
   json_response(current_user.dislikes, :created)
  end
  
  # DELETE /dislikes/:id
  def destroy
   @dislike = Dislike.find(params[:id])
   @dislike.destroy
   head :no_content
  end

  swagger_api :index do
    summary 'Show  all likes'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  swagger_api :show do
    summary 'Show  dislike'
    param :path, :id, :integer, :required, 'Dislike id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  swagger_api :create do
    summary 'Create dislikes'
    param :form, :property_id, :integer, :required, 'Property id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  swagger_api :destroy do
    summary 'Delete dislike'
    param :path, :id, :integer, :required, 'Like id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end
  
end
