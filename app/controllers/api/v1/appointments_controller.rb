class Api::V1::AppointmentsController < ApplicationController
  def create
    token =
      Stripe::Token.create(
        card: {
          number: payment_params[:number],
          exp_month: payment_params[:exp_month],
          exp_year: payment_params[:exp_year],
          cvc: payment_params[:cvc],
          name: payment_params[:name]
        }
      )
    customer =
      Stripe::Customer.create(
        {
          customer: @current_user[:stripe_id],
          name: "#{@current_user[:first_name]} #{@current_user[:last_name]}",
          email: @current_user[:email],
          source: token
        }
      )
    charge =
      Stripe::Charge.create(
        { customer: customer, amount: payment_params[:amount], currency: 'php' } #10,000 = PHP 100.00
      )

    render json: charge
  end

  private

  def payment_params
    params.require(:data).permit(
      :number,
      :exp_month,
      :exp_year,
      :cvc,
      :name,
      :amount
    )
  end
end
