class FavouritesController < ApplicationController
  
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
  
end
