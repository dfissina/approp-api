class LikesController < ApplicationController
  
  # GET /likes
  def index
   json_response(current_user.likes)
  end
 
  # GET /likes/:id
  def show
   @like = Like.find(params[:id])
   json_response(@like)
  end
   
  # POST /likes
  def create
   property = Property.find(params[:property_id])
   current_user.likes.create!(property_id: property.id) 
   json_response(current_user.likes, :created)
  end
  
  # DELETE /likes/:id
  def destroy
   @like = Like.find(params[:id])
   @like.destroy
   head :no_content
  end
  
end
