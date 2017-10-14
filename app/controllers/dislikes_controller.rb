class DislikesController < ApplicationController
  
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
  
end
