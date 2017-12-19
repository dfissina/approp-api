class DocumentsController < ApplicationController

  swagger_controller :comunas, 'User Documents Managment'
  
  before_action :set_user, only: [:index, :show, :create, :update, :destroy]

  swagger_api :index do
    summary 'Show  all documents by user'
    param :path, :user_id, :integer, :required, 'User id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  # GET /user/:user_id/documents
  def index
    render json: @user, serializer: UserDocumentsSerializer
  end

  swagger_api :create do
    summary 'Create User Document'
    param :path, :user_id, :integer, :required, 'User id'
    param :form, :document_type_id, :integer, :required, 'Document Type'
    param :form, "document", :file, :required, 'Document'
    param :header, :Authorization, :string, :required, 'Authorization'
  end

  # POST /users/:user_id/documents
  def create
    @user.documents.new(document: params[:document], document_type_id: params[:document_type_id])
    @user.save!
    render json: @user.documents.last, status: :created
  end

  swagger_api :show do
    summary 'Show User Documents'
    param :path, :user_id, :integer, :required, 'User id'
    param :path, :id, :integer, :required, 'Document id'
    param :header, :Authorization, :string, :required, 'Authorization'
  end

  # GET /user/:user_id/documents/:id
  def show
   @document = @user.documents.find_by!(id: params[:id])
   json_response(@document)
  end

  swagger_api :update do
    summary 'Update User Document'
    param :path, :user_id, :integer, :required, 'User id'
    param :path, :id, :integer, :required, 'Document id'
    param :form, "document", :file, :required, 'Document'
    param :header, :Authorization, :string, :required, 'Authorization'
  end

  # PUT /users/:user_id/documents/:id
  def update
    @document = @user.documents.find_by!(id: params[:id])
    @document.update(document: params[:document])
    head :no_content
  end

  swagger_api :destroy do
    summary 'Delete User Document'
    param :path, :user_id, :integer, :required, 'User id'
    param :path, :id, :integer, :required, 'Document id'
    param :header, :Authorization, :string, :required, 'Authorization'
  end

  # DELETE /users/:user_id/documents/:id
  def destroy
    @document = @user.documents.find_by!(id: params[:id])
    @document.destroy
    head :no_content
  end
     
  private

  def set_user
    if params[:user_id].present?
      @user = User.find(params[:user_id])
    end
  end
    
  def comuna_params
    # whitelist params
    params.permit(
      :document_type_id, 
      :user_id, 
      :document
    )
  end  
  
end
