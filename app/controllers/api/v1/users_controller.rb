class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request,
                     :is_email_verified?,
                     only: [:create_patient]
  before_action :restrict_user, only: %i[users user]
  before_action :restrict_patient, only: [:patients]
  before_action :set_user, only: %i[user destroy_user]

  def users
    users = User.all.each.select { |user| user.roles.first != admin_role }
    render json: users, status: :ok
  end

  def doctors
    doctors = User.all.each.select { |user| user.roles.first == doctor_role }
    render json: doctors, status: :ok
  end

  def patients
    patients = User.all.each.select { |user| user.roles.first == patient_role }
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

  def destroy_current_user
    @current_user.destroy
    render json: {
             messages: ['Your account has been successfully deleted!']
           },
           status: :ok
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
