class AppropMailer < ApplicationMailer

  def recovery_mail(user)
    @user = user
    mail(to: @user.email, subject: 'Approp password recovery')
  end
end
