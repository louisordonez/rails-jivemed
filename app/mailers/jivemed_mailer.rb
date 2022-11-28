class JivemedMailer < ApplicationMailer
  default from: 'jivemed.mailer@gmail.com'

  def confirm_email
    @user = params[:user]
    @email_token = params[:email_token]
    @url = "#{ENV['JIVEMED_CONFIRM_EMAIL_URL']}#{@email_token}"
    mail(to: @user.email, subject: 'Welcome to Jivemed!')
  end
end
