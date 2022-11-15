class Api::V1::TransactionsController < ApplicationController
  def create
    token =
      Stripe::Token.create(
        card: {
          number: transaction_params[:number],
          exp_month: transaction_params[:exp_month],
          exp_year: transaction_params[:exp_year],
          cvc: transaction_params[:cvc],
          name: transaction_params[:name]
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
    charge =
      Stripe::Charge.create(
        {
          customer: customer,
          amount: transaction_params[:amount], #100025 = PHP 1000.25
          currency: 'php'
        }
      )
    @transaction =
      Transaction.new(
        {
          user_id: @current_user.id,
          first_name: @current_user.first_name,
          last_name: @current_user.last_name,
          email: @current_user.email,
          stripe_id: charge[:id],
          amount: charge[:amount].to_f / 100
        }
      )

    if charge
      render json: { transaction: @transaction } if @transaction.save
    end
  end

  private

  def transaction_params
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
