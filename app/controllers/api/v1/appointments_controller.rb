class Api::V1::AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show]

  def index
    appointments = Appointment.all

    render json: {
             appointments:
               appointments.map do |appointment|
                 {
                   details: appointment,
                   patient: appointment.user,
                   schedule: appointment.schedule,
                   doctor: appointment.schedule.user,
                   transaction: appointment.user_transaction
                 }
               end
           },
           status: :ok
  end

  def show
    render json: {
             appointment: {
               details: @appointment,
               patient: @appointment.user,
               schedule: @appointment.schedule,
               doctor: @appointment.schedule.user,
               transaction: @appointment.user_transaction
             }
           },
           status: :ok
  end

  def create
    token =
      Stripe::Token.create(
        card: {
          name: card_params[:name],
          number: card_params[:number],
          exp_month: card_params[:exp_month],
          exp_year: card_params[:exp_year],
          cvc: card_params[:cvc]
        }
      )
    customer =
      Stripe::Customer.create(
        {
          customer: @current_user.stripe_id,
          name: "#{@current_user.first_name} #{@current_user.last_name}",
          email: @current_user.email,
          source: token
        }
      )
    amount =
      Schedule
        .find(appointment_params[:schedule_id])
        .user
        .doctor_fee
        .amount
        .to_i * 100
    charge =
      Stripe::Charge.create(
        { customer: customer, amount: amount, currency: 'php' }
      )
    user_transaction =
      UserTransaction.new(
        {
          user_id: @current_user.id,
          email: @current_user.email,
          stripe_id: charge[:id],
          amount: charge[:amount].to_f / 100
        }
      )
    if charge
      if user_transaction.save
        appointment =
          Appointment.new(
            {
              user_id: @current_user.id,
              schedule_id: appointment_params[:schedule_id],
              user_transaction_id: user_transaction.id
            }
          )
        if appointment.save
          update_schedule = Schedule.find(appointment_params[:schedule_id])
          update_schedule.update(available: update_schedule.available - 1)

          render json: {
                   appointment: {
                     details: appointment,
                     patient: appointment.user,
                     schedule: appointment.schedule,
                     doctor: appointment.schedule.user
                   }
                 },
                 status: :ok
        else
          render json: {
                   errors: {
                     messages: appointment.errors.full_messages
                   }
                 },
                 status: :unprocessable_entity
        end
      else
        render json: {
                 errors: {
                   messages: user_transaction.errors.full_messages
                 }
               },
               status: :unprocessable_entity
      end
    end
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
             errors: {
               messages: ['Record not found.']
             }
           },
           status: :not_found
  end

  def card_params
    params.require(:card).permit(:name, :number, :exp_month, :exp_year, :cvc)
  end

  def appointment_params
    params.require(:appointment).permit(:schedule_id)
  end
end
