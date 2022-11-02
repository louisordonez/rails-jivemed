class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request,
                     :email_verified?,
                     only: [:create_patient]
  before_action :set_user, only: %i[show destroy]

  def index
    @users = User.all
    render json: @users, status: :ok
  end

  def show
    render json: @users, status: :ok
  end

  def create_patient
    @user = User.new(user_params)

    if @user.save
      payload = { user_email: @user.email }
      email_token = JsonWebToken.encode(payload, 7.days.from_now)
      render json: {
               user: @user,
               email_token: email_token,
               messages: ['A confirmation email has been sent!']
             },
             status: :created
    else
      render json: {
               errors: {
                 messages: @user.errors.full_messages
               }
             },
             status: :unprocessable_entity
    end
  end

  def update
    unless @user.update(user_params)
      render json: {
               errors: {
                 messages: @user.errors.full_messages
               }
             },
             status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
  end

  private

  def set_user
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {
               errors: {
                 messages: ['Record not found.']
               }
             },
             status: :not_found
    end
  end

  def user_params
    params.permit(:first_name, :last_name, :email, :password)
  end
end
