class Api::V1::UserTransactionsController < ApplicationController
  before_action :set_user_transaction, only: [:show]

  def index
    user_transactions = UserTransaction.all

    render json: {
             transactions:
               user_transactions.map { |transaction|
                 { details: transaction, user: transaction.user }
               }
           },
           status: :ok
  end

  def show
    render json: {
             details: @user_transaction,
             user: @user_transaction.user
           },
           status: :ok
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
