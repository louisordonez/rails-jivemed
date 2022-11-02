class ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authenticate_request, :email_verified?

  private

  def email_verified?
    if !@current_user.email_verified
      render json: {
               errors: {
                 messages: ['Email needs to be verified to continue.']
               }
             },
             status: :forbidden
    end
  end

  def authenticate_request
    authorization = request.headers['Authorization']
    if authorization
      access_token = authorization.split(' ').last
      begin
        decoded = JsonWebToken.decode(access_token)
        @current_user = User.find(decoded[:user_id])
      rescue ActiveRecord::RecordNotFound
        render json: {
                 errors: {
                   messages: ['Record not found.']
                 }
               },
               status: :not_found
      rescue JWT::ExpiredSignature
        render json: {
                 errors: {
                   messages: ['Token has expired. Please sign in to continue.']
                 }
               },
               status: :unauthorized
      rescue JWT::DecodeError
        render json: {
                 errors: {
                   messages: ['Invalid token.']
                 }
               },
               status: :unprocessable_entity
      end
    else
      render json: {
               errors: {
                 messages: ['Please sign in to continue.']
               }
             },
             status: :forbidden
    end
  end
end
