class ComunasController < ApplicationController

  swagger_controller :comunas, 'Comunas Managment'

  skip_before_action :authorize_request, only: [:index, :create, :show, :update, :destroy]
    
  before_action :set_comuna, only: [:show, :update, :destroy]

  swagger_api :index do
    summary 'Show  all comunas'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  # GET /comunas
  def index
    @comunas = Comuna.all
    json_response(@comunas)
  end

  swagger_api :create do
    summary 'Create comuna'
    param :form, :name, :string, :required, 'Nombre'
    param :form, :lat, :float, :required, 'Latitud'
    param :form, :lng, :float, :required, 'Longitud'
    param :form, :region_id, :integer, :required, 'Region id'
    param :header, :Authorization, :string, :required, 'Authorization'
  end

  # POST /comunas
  def create
    @comuna = Comuna.create!(comuna_params)
    json_response(@comuna, :created)
  end

  swagger_api :show do
    summary 'Show comuna'
    param :path, :id, :integer, :required, 'Comuna id'
    param :header, :Authorization, :string, :required, 'Authorization'
  end

  # GET /comunas/:id
  def show
   json_response(@comuna)
  end

  swagger_api :update do
    summary 'Update comuna'
    param :path, :id, :integer, :required, 'Comuna id'
    param :form, :name, :string, :optional, 'Nombre'
    param :form, :lat, :float, :optional, 'Latitud'
    param :form, :lng, :float, :optional, 'Longitud'
    param :form, :region_id, :integer, :optional, 'Region id'
    param :header, :Authorization, :string, :required, 'Authorization'
  end

  # PUT /comunas/:id
  def update
    @comuna.update(comuna_params)
    head :no_content
  end

  swagger_api :destroy do
    summary 'Delete comuna'
    param :path, :id, :integer, :required, 'Comuna id'
    param :header, :Authorization, :string, :required, 'Authorization'
  end

  # DELETE /comunas/:id
  def destroy
    @comuna.destroy
    head :no_content
  end
     
  private

  def comuna_params
    # whitelist params
    params.permit(
      :name, 
      :lat, 
      :lng,
      :region_id
    )
  end
  
  def set_comuna
    @comuna = Comuna.find(params[:id])
  end
end
