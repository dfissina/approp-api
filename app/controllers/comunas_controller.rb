class ComunasController < ApplicationController
  
  skip_before_action :authorize_request, only: [:index, :create, :show, :update, :destroy]
    
  before_action :set_comuna, only: [:show, :update, :destroy]
      
  # GET /comunas
  def index
    @comunas = Comuna.all
    json_response(@comunas)
  end

  # POST /comunas
  def create
    @comuna = Comuna.create!(comuna_params)
    json_response(@comuna, :created)
  end

  # GET /comunas/:id
  def show
   json_response(@comuna)
  end

  # PUT /comunas/:id
  def update
    @comuna.update(comuna_params)
    head :no_content
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
