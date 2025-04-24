class Api::V1::TransactionsController < ApplicationController
  def single
    transaction = Transaction.new(transaction_params)
    data = ExternalTransactionService.process_transaction(transaction_params)
    transaction.status = data["status"]
    transaction.amount = data["amount"]
    transaction.transaction_reference = data["transaction_reference"]
    if transaction.save
      render json: { status: transaction.status, transaction_id: transaction.transaction_id }, status: :ok
    else
      render json: { error: transaction.errors.messages }, status: :unprocessable_entity
    end

  end

  def bulk
    transactions = ExternalTransactionService.bulk_process(bulk_transaction_params)
    Transaction.insert_all(transactions)
    render json: { status: transactions_status?(transactions), processed_count: transactions.size }
  end

  private

  def transactions_status?(transactions)
    transactions.any? { |trans| trans["status"] == :failed } ? "failed" : "successs"
  end

  def transaction_params
    params.permit(:transaction_id, :points, :user_id)
  end

  def bulk_transaction_params
    params.require(:transactions).map do |t|
      t.permit(:transaction_id, :points, :user_id).to_h
    end
  end

end
