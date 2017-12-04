# app/controllers/authentication_controller.rb
class AuthenticationController < ApplicationController

  swagger_controller :authentication, 'Authentication Managment'
  
  skip_before_action :authorize_request, only: [:authenticate, :facebook]
  
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
  
  def facebook
    user = User.find_by_email(auth_params[:email])
    user =  User.new(facebook_user_params) if !user.present?
    random_password = User.generate_password
    user.password = random_password
    user.password_confirmation = random_password
    user.remote_profile_picture_url = auth_params[:picture]
    user.save!
    auth_token = AuthenticateUser.new(user.email, user.password).call
    render json: { auth_token: auth_token}
  end


  private

  def auth_params
    params.permit(:email, :password, :password_digest, :first_name, :last_name, :picture, :birthday)
  end

  def facebook_user_params
    {
      email: auth_params[:email],
      first_name: auth_params[:first_name],
      last_name: auth_params[:last_name],
      birth_date: '01-01-2017',
      phone: 'N/A',
      cell_phone: 'N/A',
      account_active: true,
      rol: 'agent'
    }
  end
end