class Api::V1::DoctorsController < ApplicationController
  before_action :restrict_user, only: [:index]

  def index
    doctors =
      User
        .all
        .select { |user| user.roles.first == doctor_role }
        .map { |user| { user: user, role: user.roles.first } }

    render json: doctors, status: :ok
  end

  def create
    doctor = User.new(doctor_params)

    if doctor.save
      doctor.update(email_verified: true)
      doctor.roles << doctor_role

      render json: { user: doctor }, status: :created
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
end
