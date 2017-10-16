class RegionsController < ApplicationController

  swagger_controller :region, 'Regiones Managment'
  
  skip_before_action :authorize_request, only: [:index, :create, :show, :update, :destroy]
  
  before_action :set_region, only: [:show, :update, :destroy]

  swagger_api :index do
    summary 'Show  all regiones'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  # GET /regions
  def index
    @regions = Region.all
    json_response(@regions)
  end

  swagger_api :create do
    summary 'Create región'
    param :form, :name, :string, :required, 'Nombre'
    param :form, :lat, :float, :required, 'Latitud'
    param :form, :lng, :float, :required, 'Longitud'
    param :header, :Authorization, :string, :required, 'Authorization'
  end

  # POST /regions
  def create
    @region = Region.create!(region_params)
    json_response(@region, :created)
  end

  swagger_api :show do
    summary 'Show región'
    param :path, :id, :integer, :required, 'Región id'
    param :header, :Authorization, :string, :required, 'Authorization'
  end

  # GET /regions/:id
  def show
   json_response(@region)
  end

  swagger_api :update do
    summary 'Update región'
    param :path, :id, :integer, :required, 'Región id'
    param :form, :name, :string, :optional, 'Nombre'
    param :form, :lat, :float, :optional, 'Latitud'
    param :form, :lng, :float, :optional, 'Longitud'
    param :header, :Authorization, :string, :required, 'Authorization'
  end

  # PUT /regions/:id
  def update
    @region.update(region_params)
    head :no_content
  end

  swagger_api :destroy do
    summary 'Delete región'
    param :path, :id, :integer, :required, 'Región id'
    param :header, :Authorization, :string, :required, 'Authorization'
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
