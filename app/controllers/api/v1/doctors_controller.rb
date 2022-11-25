class Api::V1::DoctorsController < ApplicationController
  before_action :set_doctor, only: [:update]
  before_action :restrict_user, only: %i[create update]

  def index
    doctors =
      User
        .all
        .select { |user| user.role == doctor_role && !user.deleted_at }
        .map do |user|
          {
            user: user,
            role: user.role,
            departments: user.departments,
            doctor_fee: user.doctor_fee
          }
        end

    render json: { users: doctors }, status: :ok
  end

  def create
    doctor = User.new(doctor_params.merge(role_id: doctor_role.id))

    if doctor.save
      doctor.update(email_verified: true)
      doctor_department_params[:department_id].each do |department_id|
        doctor.departments << Department.find_by(id: department_id)
      end

      doctor.create_doctor_fee(amount: doctor_fee_params[:amount])

      render json: {
               user: doctor,
               role: doctor.role,
               departments: doctor.departments,
               doctor_fee: doctor.doctor_fee
             },
             status: :created
    else
      show_errors(doctor)
    end
  end

  def update
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

    if @doctor.update(doctor_params)
      if departments
        @doctor.departments.destroy_all
        departments.each do |department_id|
          @doctor.departments << Department.find_by(id: department_id)
        end
      end

      @doctor.doctor_fee.update(amount: doctor_fee) if doctor_fee

      user = {
        user: @doctor,
        role: @doctor.role,
        departments: @doctor.departments,
        doctor_fee: @doctor.doctor_fee
      }

      render json: user, status: :ok
    else
      show_errors(@doctor)
    end
  end

  private

  def set_doctor
    @doctor = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
             errors: {
               messages: ['Record not found.']
             }
           },
           status: :not_found
  end

  def doctor_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

  def doctor_department_params
    params.require(:department).permit(department_id: [])
  end

  def doctor_fee_params
    params.require(:doctor_fee).permit(:amount)
  end
end
