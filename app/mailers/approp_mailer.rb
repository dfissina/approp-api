class AppropMailer < ApplicationMailer

  def recovery_mail(user)
    @user = user
    attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/img/logo.png")
    attachments.inline["face.png"] = File.read("#{Rails.root}/app/assets/img/facebook-128.png")
    attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/img/twitter-128.png")
    attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/img/linkedin-128.png") 
    mail(to: @user.email, subject: 'Approp - Nueva clave de acceso') do |format|
      format.html
    end
  end
  
  def message_contact_mail(message, user, property)
    @user = user
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
    mail(to: @user.email, subject: 'Approp - Nuevo mensaje de contacto') do |format|
      format.html
    end
  end
end
