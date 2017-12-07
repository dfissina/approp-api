class StatisticsController < ApplicationController

  swagger_controller :statistics, 'Statistics Managment'
  
  #skip_before_action :authorize_request, only: [:index, :create, :show, :update, :destroy]
  
  swagger_api :index do
    summary 'Show statistics'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  # GET /statistics
  def index
    return json_response({error: "No tiene permisos para consultar estadísticas."}, :unprocessable_entity) if !current_user.admin? 
    users =  User.all
    json_response({users_size: users.size})
  end
  
end
