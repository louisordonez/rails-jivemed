class Api::V1::AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show]

  def index
    appointments =
      Appointment.all.map do |appointment|
        {
          details: appointment,
          patient: appointment.user,
          schedule: appointment.schedule,
          doctor: appointment.schedule.user,
          transaction: appointment.user_transaction
        }
      end

    render json: { appointments: appointments }, status: :ok
  end

  def show
    appointment = {
      details: @appointment,
      patient: @appointment.user,
      schedule: @appointment.schedule,
      doctor: @appointment.schedule.user,
      transaction: @appointment.user_transaction
    }

    render json: { appointment: appointment }, status: :ok
  end

  def create
    begin
      card = {
        card: {
          name: card_params[:name],
          number: card_params[:number],
          exp_month: card_params[:exp_month],
          exp_year: card_params[:exp_year],
          cvc: card_params[:cvc]
        }
      }
      token = Stripe::Token.create(card)
      name = "#{@current_user.first_name} #{@current_user.last_name}"
      customer = {
        customer: @current_user.stripe_id,
        name: name,
        email: @current_user.email,
        source: token
      }
      customer = Stripe::Customer.create(customer)
      amount =
        Schedule
          .find(appointment_params[:schedule_id])
          .user
          .doctor_fee
          .amount
          .to_i * 100
      charge = { customer: customer, amount: amount, currency: 'php' }
      charge = Stripe::Charge.create(charge)
      user_transaction = {
        user_id: @current_user.id,
        email: @current_user.email,
        stripe_id: charge[:id],
        amount: charge[:amount].to_f / 100
      }
      user_transaction = UserTransaction.new(user_transaction)

      if user_transaction.save
        appointment = {
          user_id: @current_user.id,
          schedule_id: appointment_params[:schedule_id],
          user_transaction_id: user_transaction.id
        }
        appointment = Appointment.new(appointment)

        if appointment.save
          update_schedule = Schedule.find(appointment_params[:schedule_id])
          update_schedule.update(available: update_schedule.available - 1)

          appointment = {
            details: appointment,
            patient: appointment.user,
            schedule: appointment.schedule,
            doctor: appointment.schedule.user
          }

          render json: { appointment: appointment }, status: :ok
        else
          show_errors(appointment)
        end
      else
        show_errors(user_transaction)
      end
    rescue Stripe::StripeError => error
      render json: { errors: error.error }, status: :unprocessable_entity
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
