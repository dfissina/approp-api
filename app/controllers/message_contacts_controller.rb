class MessageContactsController < ApplicationController

  swagger_controller :message, 'Messages Managment'

  swagger_api :index do
    summary 'Show  all messages'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  # GET /messages
  def index
    @messages = MessageContact.all
    json_response(@messages)
  end

  swagger_api :create do
    summary 'Create message'
    param :form, :name, :string, :required, 'Nombre'
    param :form, :email, :string, :required, 'Email'
    param :form, :phone, :string, :optional, 'Telefono'
    param :form, :message, :string, :required, 'Mensaje'
    param :form, :property_id, :integer, :required, 'Property id'
    param :header, :Authorization, :string, :required, 'Authorization'
  end

  # POST /messages
  def create   

    @message = MessageContact.new(
      email: message_contacts_params[:email],
      name: message_contacts_params[:name],
      phone: message_contacts_params[:phone],
      message: message_contacts_params[:message],
      property_id: message_contacts_params[:property_id],
      user_id: current_user.id
    )
    
    property = Property.find(params[:property_id])
    user_to = User.find_by_email(property.user.email) if property.user.email
    
    if @message.save! && !user_to.email.blank?
      AppropMailer.message_contact_mail(@message, user_to, property).deliver
      json_response({status: 'Mensaje enviado a:'+property.user.email}, :created)
    else
      json_response({error: 'El destinatario no tiene un email cargado en Approp'}, :unprocessable_entity)      
    end
  end 
     
  private

  def message_contacts_params
    # whitelist params
    params.permit(
      :name, 
      :phone, 
      :email,
      :message,
      :property_id,
      :user_id,
      #:user
    )
  end
end
