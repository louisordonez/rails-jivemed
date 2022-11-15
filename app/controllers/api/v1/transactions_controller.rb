class Api::V1::TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show]

  def index
    transactions = Transaction.all

    render json: {
             transaction: transactions,
             user: transactions.map { |transaction| transaction.user },
             appointment:
               transactions.map { |transaction|
                 {
                   details: transaction.appointment,
                   schedule: transaction.appointment.schedule,
                   doctor: transaction.appointment.schedule.user
                 }
               }
           }
  end

  def show
    render json: {
             transaction: @transaction,
             user: @transaction.user,
             appointment: {
               details: @transaction.appointment,
               schedule: @transaction.appointment.schedule,
               doctor: @transaction.appointment.schedule.user
             }
           }
  end

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
          amount: transaction_params[:amount],
          currency: 'php'
        }
      )
    @transaction =
      Transaction.new(
        {
          user_id: @current_user.id,
          email: @current_user.email,
          stripe_id: charge[:id],
          amount: charge[:amount].to_f / 100
        }
      )

    if charge
      if @transaction.save
        render json: { transaction: @transaction, user: @current_user }
      end
    end
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
             errors: {
               messages: ['Record not found.']
             }
           },
           status: :not_found
  end

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
