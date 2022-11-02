class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def sign_in
    @user = User.find_by_email(params[:email])
    if (@user&.authenticate(params[:password]))
      payload = { user_id: @user.id }
      exp = 7.days.from_now.to_i
      access_token = JsonWebToken.encode(payload, exp)
      render json: {
               user: @user,
               expiration: exp,
               access_token: access_token
             },
             status: :ok
    else
      render json: {
               error: {
                 message: 'Invalid credentials.'
               }
             },
             status: :unauthorized
    end
  end
end
