class AppropMailer < ApplicationMailer

  def recovery_mail(user, accountHash)
    @user = user
    @accountHash = accountHash
    attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/img/logo.png")
    attachments.inline["face.png"] = File.read("#{Rails.root}/app/assets/img/facebook-128.png")
    attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/img/twitter-128.png")
    attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/img/linkedin-128.png") 
    mail(to: @user.email, subject: 'Approp - Nueva clave de acceso') do |format|
      format.html
    end
  end
  
  def message_contact_mail(message, user_to, user_from, property, send_documents)
    @user_to = user_to
    @user_from = user_from
    @message = message
    @property = property
    attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/img/logo.png")
    if @property.property_photos.size > 0 && @property.property_photos.first.photo? 
      attachments.inline["property_principal.jpg"] = File.read("#{Rails.root}/public"+@property.property_photos.first.photo.url)
    else
      attachments.inline["property_principal.jpg"] = File.read("#{Rails.root}/app/assets/img/no-property-photo.jpg")
    end       
    attachments.inline["face.png"] = File.read("#{Rails.root}/app/assets/img/facebook-128.png")
    attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/img/twitter-128.png")
    attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/img/linkedin-128.png")
     
    if send_documents == "true"     
      @user_from.documents.each do |document|
        document_type_name = document.document_type.name.downcase
        document_type_name = document_type_name.gsub! ' ', '_'
        document_type_name = document_type_name + '_' + document.order.to_s + '.' + document.document.url.split('.')[1]       
        attachments[document_type_name] = {:mime_type => 'application/x-gzip', 
                                           :content => File.read("#{Rails.root}/public/"+document.document.url)}
      end
    end    
    mail(to: @user_to.email, subject: 'Approp - Nuevo mensaje de contacto') do |format|
      format.html
    end
  end

  def account_created(user, accountHash)
    @user = user
    @accountHash = accountHash
    attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/img/logo.png")
    attachments.inline["face.png"] = File.read("#{Rails.root}/app/assets/img/facebook-128.png")
    attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/img/twitter-128.png")
    attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/img/linkedin-128.png")
    mail(to: @user.email, subject: 'Approp - Activación de Cuenta') do |format|
      format.html
    end
  end

  def new_email(user, accountHash)
    @user = user
    @accountHash = accountHash
    attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/img/logo.png")
    attachments.inline["face.png"] = File.read("#{Rails.root}/app/assets/img/facebook-128.png")
    attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/img/twitter-128.png")
    attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/img/linkedin-128.png")
    mail(to: @accountHash.temp_email, subject: 'Approp - Cambio de email') do |format|
      format.html
    end
  end
end
