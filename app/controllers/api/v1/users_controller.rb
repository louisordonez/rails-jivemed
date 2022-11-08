class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request,
                     :is_email_verified?,
                     only: [:create_patient]
  before_action :restrict_user, only: %i[users user]
  before_action :restrict_patient, only: [:patients]
  before_action :set_user, only: %i[user update_user destroy_user]

  def users
    users =
      User
        .all
        .select { |user| user.roles.first != admin_role }
        .map { |user| { user: user, role: user.roles.first } }

    render json: users, status: :ok
  end

  def doctors
    doctors =
      User
        .all
        .select { |user| user.roles.first == doctor_role }
        .map { |user| { user: user, role: user.roles.first } }

    render json: doctors, status: :ok
  end

  def patients
    patients =
      User
        .all
        .select { |user| user.roles.first == patient_role }
        .map { |user| { user: user, role: user.roles.first } }

    render json: patients, status: :ok
  end

  def user
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

  def update_user
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

  def destroy_user
    if (is_admin_role?(@user))
      render json: {
               errors: {
                 messages: ['Cannot delete admin account.']
               }
             },
             status: :forbidden
    else
      @user.destroy

      render json: {
               user: @user,
               messages: ['User has been successfully deleted!']
             },
             status: :ok
    end
  end

  def current_user
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
