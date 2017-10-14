class RegionsController < ApplicationController
  
  skip_before_action :authorize_request, only: [:index, :create, :show, :update, :destroy]
  
  before_action :set_region, only: [:show, :update, :destroy]
    
  # GET /regions
  def index
    @regions = Region.all
    json_response(@regions)
  end

  # POST /regions
  def create
    @region = Region.create!(region_params)
    json_response(@region, :created)
  end

  # GET /regions/:id
  def show
   json_response(@region)
  end

  # PUT /regions/:id
  def update
    @region.update(region_params)
    head :no_content
  end

  # DELETE /regions/:id
  def destroy
    @region.destroy
    head :no_content
  end
     
  private

  def region_params
    # whitelist params
    params.permit(
      :name, 
      :lat, 
      :lng
    )
  end
  
  def set_region
    @region = Region.find(params[:id])
  end
  
end
