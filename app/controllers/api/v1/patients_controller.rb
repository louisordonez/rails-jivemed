class Api::V1::PatientsController < ApplicationController
  skip_before_action :authenticate_request, :email_verified, only: [:create]
  before_action :set_patient, only: [:update]
  before_action :restrict_user, only: [:index]

  def index
    patients =
      User
        .all
        .select { |user| user.role == patient_role && !user.deleted_at }
        .map { |user| { user: user, role: user.role } }

    render json: { users: patients }, status: :ok
  end

  def create
    patient = User.new(patient_params.merge(role_id: patient_role.id))

    if patient.save
      payload = { user_email: patient.email }
      email_token = JsonWebToken.encode(payload, 24.hours.from_now)

      JivemedMailer
        .with(user: patient, email_token: email_token)
        .confirm_email
        .deliver_now

      render json: { user: patient, email_token: email_token }, status: :created
    else
      show_errors(patient)
    end
  end

  def admin_create
    patient = User.new(patient_params.merge(role_id: patient_role.id))

    if (is_admin_role?(@current_user))
      if patient.save
        patient.update(email_verified: true)
        render json: { user: patient }, status: :created
      else
        show_errors(patient)
      end
    end
  end

  def update
    if @patient.update(patient_params)
      user = { user: @patient, role: @patient.role }

      render json: user, status: :ok
    else
      show_errors(@patient)
    end
  end

  private

  def set_patient
    @patient = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
             errors: {
               messages: ['Record not found.']
             }
           },
           status: :not_found
  end

  def patient_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
