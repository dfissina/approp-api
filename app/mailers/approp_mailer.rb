class AppropMailer < ApplicationMailer

  def recovery_mail(user)
    @user = user
    mail(to: @user.email, subject: 'Approp - Password recovery')
  end
  
  def message_contact_mail(message, user, property)
    @user = user
    @message = message
    @property = property
    attachments.inline["logo.jpg"] = File.read("#{Rails.root}/app/assets/img/logo.jpg")
    attachments.inline["property_principal.jpg"] = File.read("#{Rails.root}/public"+@property.property_photos.first.photo.url)
    attachments.inline["face.png"] = File.read("#{Rails.root}/app/assets/img/facebook-128.png")
    attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/img/twitter-128.png")
    attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/img/linkedin-128.png")    
    mail(to: @user.email, from: 'contacto@approp.cl', subject: 'Approp - Nuevo mensaje de contacto') do |format|
      format.html
    end
  end
end
