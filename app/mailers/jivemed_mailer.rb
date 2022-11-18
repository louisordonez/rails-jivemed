class JivemedMailer < ApplicationMailer
  default from: 'jivemed.mailer@gmail.com'

  def confirm_email
    @user = params[:user]
    @email_token = params[:email_token]
    @url =
      "http://localhost:3000/api/v1/auth/verify?email_token=#{@email_token}"
    mail(to: @user.email, subject: 'Welcome to Jivemed!')
  end
end
