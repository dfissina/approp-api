class UsersController < ApplicationController

  swagger_controller :users, 'Users Managment'
  
  skip_before_action :authorize_request, only: [:create, :recovery]
  
  before_action :set_user, only: [:show, :update, :destroy]

  swagger_api :index do
    summary 'List Users'
    param :header, :Authorization, :string, :required, 'Token'
  end

  # GET /users
  def index
    @users = User.all
    json_response(@users)
  end

  swagger_api :create do
    summary 'Sign Up'
    param :form, :first_name, :string, :required, 'Nombre'
    param :form, :last_name, :string, :required, 'Apellido'
    param :form, :email, :email, :required, 'Email'
    param :form, :password, :string, :required, 'Constraseña'
    param_list :form, :rol, :string, :required, 'Rol', ['customer', 'agent', 'admin']
    param :form, :birth_date, :string, :required, 'Fecha Nacimiento'
    param :form, :phone, :string, :required, 'Teléfono'
    param :form, :cell_phone, :string, :required, 'Teléfono Celular'
  end

  # POST /signup
  # return authenticated token upon signup
  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.account_created, auth_token: auth_token }
    json_response(response, :created)
  end

  swagger_api :show do
    summary 'Show user'
    param :path, :id, :integer, :required, 'Id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  # GET /users/:id
  def show
   json_response(@user)
  end

  swagger_api :update do
    summary 'Edit user'
    param :path, :id, :integer, :required, 'Id'
    param :form, :first_name, :string, :optional, 'Nombre'
    param :form, :last_name, :string, :optional, 'Apellido'
    param :form, :email, :string, :optional, 'Email'
    param :form, :password, :string, :optional, 'Password'
    param :form, :birth_date, :string, :optional, 'Fecha Nacimiento'
    param :form, :phone, :string, :optional, 'Teléfono'
    param :form, :cell_phone, :string, :optional, 'Celular'
    param :header, :Authorization, :string, :required, 'Authorization'
  end

  # PUT /users/:id
  def update
    if (user_params[:password])
      @user.password = user_params[:password]
      @user.password_reseted = false
    end
    @user.update(user_params)
    head :no_content
  end

  swagger_api :destroy do
    summary 'Delete user'
    param :path, :id, :integer, :required, 'Id'
    param :header, :Authorization, :string, :required, 'Authorization'
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    head :no_content
  end
   
  # GET /users/profile
  def profile
   json_response(current_user)
  end

  swagger_api :recovery do
    summary 'Recovery Password'
    param :form, :email, :string, :required, 'Email'
  end

  # GET /users/:email/recovery
  def recovery
    if params[:email].blank?
      render json: {error: 'Email cannot be blank'}
    end

    # @users = User.all
    # user = @users.where(email: params[:email])
    user = User.find_by_email(params[:email])

    if user.present?
      if user.generate_password_token!

        AppropMailer.recovery_mail(user).deliver

        render json: {
            status: 'Password has been reseted',
            new_password: user.password
        }
      end
    else
      render json: {error: 'User not found'}
    end
  end
    
  private

  def user_params
    # whitelist params
    params.permit(
      :first_name, 
      :last_name, 
      :email, 
      :password, 
      :birth_date, 
      :phone, 
      :cell_phone,
      :password_confirmation,
      :rol
    )
  end
  
  def set_user
    @user = User.find(params[:id])
  end
end
