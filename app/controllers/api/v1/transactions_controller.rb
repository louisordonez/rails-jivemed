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
          customer: @current_user[:stripe_id],
          name: "#{@current_user[:first_name]} #{@current_user[:last_name]}",
          email: @current_user[:email],
          source: token
        }
      )
    charge =
      Stripe::Charge.create(
        {
          customer: customer,
          amount: transaction_params[:amount],
          currency: 'php' #10,000 = PHP 100.00
        }
      )

    @transaction =
      Transaction.new(
        {
          user_id: @current_user.id,
          stripe_id: charge[:id],
          amount: charge[:amount]
        }
      )

    render json: charge if @transaction.save
  end

  private

  def transaction_params
    params.require(:data).permit(
      :user_id,
      :number,
      :exp_month,
      :exp_year,
      :cvc,
      :name,
      :amount
    )
  end
end
