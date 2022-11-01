class ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authenticate_request, :email_verified?

  private

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    decoded = jwt_decode(header)
    @current_user = User.find(decoded[:user_id])
  end

  def email_verified?
    if !@current_user.email_verified
      render json: {
               error: {
                 message: 'Account needs to be verified to continue.'
               }
             },
             status: :forbidden
    end
  end
end
