class Api::V1::DoctorsController < ApplicationController
  before_action :restrict_user, only: [:create]

  def index
    doctors =
      User
        .all
        .select { |user| user.role == doctor_role }
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
      doctor.departments << Department.find_by(
        id: doctor_department_params[:department_id]
      )
      doctor.create_doctor_fee(amount: doctor_fee_params[:amount])

      render json: {
               user: doctor,
               role: doctor.role,
               departments: doctor.departments,
               doctor_fee: doctor.doctor_fee
             },
             status: :created
    else
      render json: {
               errors: {
                 messages: doctor.errors.full_messages
               }
             },
             status: :unprocessable_entity
    end
  end

  private

  def doctor_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

  def doctor_department_params
    params.require(:department).permit(:department_id)
  end

  def doctor_fee_params
    params.require(:fee).permit(:amount)
  end
end
