class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def verify_email
    token = params[:token]

    begin
      decoded = JsonWebToken.decode(token)
      @user = User.find_by_email(decoded[:user_email])
      
      raise ActiveRecord::RecordNotFound if !@user
    rescue ActiveRecord::RecordNotFound
      render json: {
               error: {
                 message: 'Record not found.'
               }
             },
             status: :not_found
    rescue JWT::ExpiredSignature
      render json: {
               error: {
                 message:
                   'Confirmation invalid. Verification token has expired.'
               }
             },
             status: :unprocessable_entity
    rescue JWT::DecodeError
      render json: {
               error: {
                 message: 'Token invalid.'
               }
             },
             status: :unprocessable_entity
    else
      if @user.email_verified
        redirect_to JIVEMED_FRONTEND_URL, allow_other_host: true
      else
        @user.update(email_verified: true)

        redirect_to JIVEMED_FRONTEND_URL, allow_other_host: true
      end
    end
  end

  def login
    @user = User.find_by_email(params[:email])

    if @user&.authenticate(params[:password])
      token = jwt_encode(user_id: @user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end
end
