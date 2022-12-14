class Api::V1::UsersController < ApplicationController
  skip_before_action :email_verified, only: [:show_current_user]
  before_action :set_user, only: %i[show update destroy]
  before_action :restrict_user, only: %i[index show update destroy]

  def index
    users =
      User
        .all
        .select { |user| user.role != admin_role && !user.deleted_at }
        .map do |user|
          {
            user: user,
            role: user.role,
            departments: user.departments,
            doctor_fee: user.doctor_fee
          }
        end

    render json: { users: users }, status: :ok
  end

  def destroyed
    users =
      User
        .all
        .select { |user| user.role != admin_role && user.deleted_at }
        .map do |user|
          {
            user: user,
            role: user.role,
            departments: user.departments,
            doctor_fee: user.doctor_fee
          }
        end

    render json: { users: users }, status: :ok
  end

  def show
    user = {
      user: @user,
      role: @user.role,
      departments: @user.departments,
      doctor_fee: @user.doctor_fee
    }

    render json: user, status: :ok
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
      @user.update(deleted_at: DateTime.now())

      render json: {
               user: @user,
               role: @user.role,
               departments: @user.departments,
               doctor_fee: @user.doctor_fee
             },
             status: :ok
    end
  end

  def show_current_user
    render json: {
             user: @current_user,
             role: @current_user.role,
             departments: @current_user.departments,
             doctor_fee: @current_user.doctor_fee
           },
           status: :ok
  end

  def update_current_user
    role = @current_user.role

    begin
      departments = doctor_department_params[:department_id]
    rescue ActionController::ParameterMissing
      departments = nil
    end

    begin
      doctor_fee = doctor_fee_params[:amount]
    rescue ActionController::ParameterMissing
      doctor_fee = nil
    end

    if @current_user.update(user_params.merge(role_id: role.id))
      if departments
        @current_user.departments.destroy_all
        departments.each do |department_id|
          @current_user.departments << Department.find_by(id: department_id)
        end
      end

      @current_user.doctor_fee.update(amount: doctor_fee) if doctor_fee

      render json: {
               user: @current_user,
               role: @current_user.role,
               departments: @current_user.departments,
               doctor_fee: @current_user.doctor_fee
             },
             status: :ok
    else
      show_errors(@current_user)
    end
  end

  def destroy_current_user
    if (is_admin_role?(@current_user))
      render json: {
               errors: {
                 messages: ['Cannot delete admin account.']
               }
             },
             status: :forbidden
    else
      @current_user.update(deleted_at: DateTime.now())

      render json: {
               user: @current_user,
               role: @current_user.role,
               departments: @current_user.departments,
               doctor_fee: @current_user.doctor_fee
             },
             status: :ok
    end
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

  def doctor_department_params
    params.require(:department).permit(department_id: [])
  end

  def doctor_fee_params
    params.require(:doctor_fee).permit(:amount)
  end
end
