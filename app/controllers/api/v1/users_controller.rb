class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request,
                     :email_verified?,
                     only: [:create_patient]
  before_action :restrict_user, only: %i[index show_user]
  before_action :set_user, only: %i[show_user destroy_user]

  def show_users
    @users = User.all.each.select { |user| user.roles.first != admin_role }
    render json: @users, status: :ok
  end

  def show_current_user
    render json: @current_user, status: :ok
  end

  def destroy_current_user
    @current_user.destroy
    render json: {
             messages: ['Your account has been successfully deleted!']
           },
           status: :ok
  end

  def show_user
    render json: @user, status: :ok
  end

  def create_patient
    @user = User.new(user_params)
    if @user.save
      @user.roles << patient_role
      payload = { user_email: @user.email }
      email_token = JsonWebToken.encode(payload, 24.hours.from_now)
      render json: {
               user: @user,
               messages: ['A confirmation email has been sent!'],
               email_token: email_token
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

  def destroy_user
    if (not_admin_role?(@user))
      @user.destroy
      render json: {
               user: @user,
               messages: ['User has been successfully deleted!']
             },
             status: :ok
    else
      render json: {
               errors: {
                 messages: ['Cannot delete admin account.']
               }
             },
             status: :forbidden
    end
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
