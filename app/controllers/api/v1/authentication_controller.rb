class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, only: [:create_user]

  def sign_in
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      token = jwt_encode(user_id: @user.id)
      render json: { token: token }, status: :ok
    else
      render json: {
               errors: {
                 messages: ['Unauthorized']
               }
             },
             status: :unauthorized
    end
  end
end
