class Api::V1::UserTransactionsController < ApplicationController
  before_action :set_user_transaction, only: [:show]

  def index
    user_transactions =
      UserTransaction.all.map do |user_transaction|
        { details: user_transaction, user: user_transaction.user }
      end

    render json: { user_transactions: user_transactions }, status: :ok
  end

  def show
    user_transaction = {
      details: @user_transaction,
      user: @user_transaction.user
    }

    render json: user_transaction, status: :ok
  end

  private

  def set_user_transaction
    @user_transaction = UserTransaction.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
             errors: {
               messages: ['Record not found.']
             }
           },
           status: :not_found
  end
end
