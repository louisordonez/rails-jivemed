class Api::V1::UsersController < ApplicationController
  # skip_before_action :authenticate_request, only: [:create_user]
  skip_before_action :authenticate_request
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
      payload = { user_id: @user.id }
      access_token = JsonWebToken.encode(payload, 7.days.from_now)
      render json: { user: @user, access_token: access_token }, status: :created
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
                 messages: ['User not found']
               }
             },
             status: :not_found
    end
  end

  def user_params
    params.permit(:first_name, :last_name, :email, :password)
  end
end
