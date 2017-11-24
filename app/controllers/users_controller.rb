class UsersController < ApplicationController

  swagger_controller :users, 'Users Managment'
  
  skip_before_action :authorize_request, only: [:create, :recovery, :exists, :activate]
  
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
    param :form, :profile_picture, :file, :optional, 'Foto de perfil'
  end

  # POST /signup
  # return authenticated token upon signup
  def create
    user = User.find_by_email(params[:email])
    if !user.present?
      user = User.create!(user_params)
      user.account_active = false
      user.save!
      accountHash = AccountHash.create(:hashcode => create_hashcode, :user_id => user.id, :password => user.password)
      AppropMailer.account_created(user, accountHash).deliver
      render json:  { message: Message.account_created, hashcode: accountHash.hashcode }
    else
      json_response({error: 'El email ya se encuentra registrado en Approp'}, :unprocessable_entity)
    end      
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
    param :form, :profile_picture, :file, :optional, 'Foto de perfil'
    param :header, :Authorization, :string, :required, 'Authorization'
  end

  # PUT /users/:id
  def update
    # Reset password
    if (user_params[:password])
      @user.password = user_params[:password]
      @user.password_reseted = false
    end

    #Email unique validation
    if (user_params[:email])
      user = User.find_by_email(user_params[:email])
      if (user.present? && user.id != @user.id)
        return json_response({error: 'El email ya se encuentra registrado en Approp'}, :unprocessable_entity)
      end 
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
   
  swagger_api :profile do
    summary 'User Profile'
    param :header, :Authorization, :string, :required, 'Authorization'
  end
  
  # GET /users/profile
  def profile
   json_response(current_user)
  end

  swagger_api :recovery do
    summary 'Recovery Password'
    param :form, :email, :string, :required, 'Email'
  end

  #POST /users/recovery
  def recovery
    if params[:email].blank?
      render json: {error: 'Email cannot be blank'}
    end

    user = User.find_by_email(params[:email])

    if user.present?
      if user.generate_password_token!
        AppropMailer.recovery_mail(user).deliver
        render json: {
            status: 'Password has been reseted'
        }
      end
    else
      render json: {error: 'User not found'}
    end
  end
  
  swagger_api :exists do
    summary 'User exists'
    param :form, :email, :string, :required, 'Email'
  end
  
  def exists
    user = User.find_by_email(params[:email])
    if user.present?
      render json: {id: user.id, status: user.present?}
    else
      render json: {status: user.present?}
    end  
  end

  #POST /users/activate
  swagger_api :activate do
    summary 'Activate account'
    param :form, :hashcode, :string, :required, 'Hashcode'
  end

  def activate
    accountHash = AccountHash.find_by_hashcode(params[:hashcode])
    user = User.find_by(id: accountHash.user_id)
    if user.present?
      user.account_active = true
      user.save!
      auth_token = AuthenticateUser.new(user.email, accountHash.password).call
      accountHash.destroy!
      render json: { message: Message.account_activated, auth_token: auth_token}
    else
      render json: { status: user.present? }
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
      :rol,
      :profile_picture
    )
  end
  
  def set_user
    @user = User.find(params[:id])
  end

  def create_hashcode
    SecureRandom.hex(20)
  end
end
