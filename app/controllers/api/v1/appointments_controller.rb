class Api::V1::AppointmentsController < ApplicationController
  def create
    @appointment =
      Appointment.new(
        appointment_params.merge(
          amount: rand(1000..10_000),
          payment_method: 'credit_card'
        )
      )

    if @appointment.save
      render json: {
               appointment: @appointment,
               payment: @appointment.payment
             },
             status: :created
    else
      render json: @response.errors, status: :unprocessable_entity
    end
  end

  private

  def appointment_params
    params.require(:data).permit(
      :user_id,
      :credit_card_number,
      :credit_card_exp_month,
      :credit_card_exp_year,
      :credit_card_cvv
    )
  end
end
