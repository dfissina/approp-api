class DislikesController < ApplicationController

  swagger_controller :dislike, 'Dislikes Managment'

  swagger_api :index do
    summary 'Show  all likes'
    param :query, :page, :integer, :optional, 'Page'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end
  
  # GET /dislikes
  def index
    if params[:page].present?
      page = params[:page]
    else
      page = 1
    end
    @dislikes =  current_user.dislikes.order('created_at DESC')
    dislikes_size = @dislikes.size
    @dislikes = @dislikes.paginate(:page => page, :per_page => 2)
    render json: {
        dislikes: ActiveModel::Serializer::CollectionSerializer.new(@dislikes, serializer: DislikeSerializer),
        total_size: dislikes_size,
        total_pages: @dislikes.total_pages
    }
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
    summary 'Delete dislike by property id'
    param :path, :property_id, :integer, :required, 'Property id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end
  
  # DELETE /dislikes/:property_id
  def destroy
    @dislike = Dislike.where(:property_id => params[:property_id]).where(:user_id => current_user.id).first
    @dislike.destroy
    head :no_content
  end

  swagger_api :getAllDislikesIds do
    summary 'All properties disliked ids'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  # GET /dislikes/ids
  def getAllDislikesIds
    dislikes = []
    current_user.dislikes.each do |dislike|
      dislikes.push(dislike.property_id)
    end
    render json: {
        dislikes_properties_ids: dislikes
    }
  end
  
end
