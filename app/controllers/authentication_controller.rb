# app/controllers/authentication_controller.rb
class AuthenticationController < ApplicationController

  swagger_controller :authentication, 'Authentication Managment'
  
  skip_before_action :authorize_request, only: :authenticate


  swagger_api :authenticate do
    summary 'Authenticate'
    param :form, :email, :string, :required, 'email'
    param :form, :password, :string, :required, 'password'
  end


  # return auth token once user is authenticated
  def authenticate
    auth_token = AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    render json: { auth_token: auth_token}
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end