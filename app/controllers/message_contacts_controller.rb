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
    param :form, :send_documents, :boolean, :required, 'Enviar documentos'
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
    
    # Volver a activar esta linea cuando el correo se vuelva a enviar al dueño de la propiedad.
    #user_to = User.find_by_email(property.user.email) if property.user.email
    
    # Ahora se envia el correo al Admin
    user_to = User.find_by_rol("admin")
    
    if @message.save! && !user_to.email.blank?
      AppropMailer.message_contact_mail(@message, user_to, current_user, property, message_contacts_params[:send_documents]).deliver
      json_response({status: 'Mensaje enviado a:'+user_to.email}, :created)
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
      :send_documents      
    )
  end
end
