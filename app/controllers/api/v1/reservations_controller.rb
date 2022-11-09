class Api::V1::ReservationsController < ApplicationController
  def create
    @reservation =
      Reservation.new(
        reservation_params.merge(
          amount: rand(1000..10_000),
          payment_method: 'credit_card'
        )
      )

    if @reservation.save
      render json: {
               reservation: @reservation,
               payment: @reservation.payment
             },
             status: :created
    else
      render json: @response.errors, status: :unprocessable_entity
    end
  end

  private

  def reservation_params
    params.require(:data).permit(
      :user_id,
      :credit_card_number,
      :credit_card_exp_month,
      :credit_card_exp_year,
      :credit_card_cvv
    )
  end
end
