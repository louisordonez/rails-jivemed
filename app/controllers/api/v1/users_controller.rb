class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request,
                     :is_email_verified?,
                     only: [:create_patient]
  before_action :set_user, only: %i[show update destroy]
  before_action :restrict_user, only: %i[index show update destroy]

  def index
    users =
      User
        .all
        .select { |user| user.roles.first != admin_role }
        .map { |user| { user: user, role: user.roles.first } }

    render json: users, status: :ok
  end

  def show
    render json: @user, status: :ok
  end

  def update
    if (is_admin_role?(@user))
      render json: {
               errors: {
                 messages: ['Cannot update admin account.']
               }
             },
             status: :forbidden
    else
      if @user.update(user_update_params)
        render json: {
                 user: @user,
                 messages: ['User has been successfully updated!']
               },
               status: :ok
      else
        render json: {
                 errors: {
                   messages: @user.errors.full_messages
                 }
               },
               status: :unprocessable_entity
      end
    end
  end

  def destroy
    if (is_admin_role?(@user))
      render json: {
               errors: {
                 messages: ['Cannot delete admin account.']
               }
             },
             status: :forbidden
    else
      @user.transactions.destroy_all
      @user.destroy

      render json: {
               user: @user,
               messages: ['User has been successfully deleted!']
             },
             status: :ok
    end
  end

  def show_current_user
    render json: @current_user, status: :ok
  end

  def update_current_user
    if @current_user.update(user_params)
      render json: {
               user: @current_user,
               messages: ['Your account has been successfully updated!']
             },
             status: :ok
    else
      render json: {
               errors: {
                 messages: @current_user.errors.full_messages
               }
             },
             status: :unprocessable_entity
    end
  end

  def destroy_current_user
    @current_user.transactions.destroy_all
    @current_user.destroy

    render json: {
             messages: ['Your account has been successfully deleted!']
           },
           status: :ok
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
             errors: {
               messages: ['Record not found.']
             }
           },
           status: :not_found
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

  def user_update_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
