class ExternalTransactionService
  include HTTParty
  base_uri 'points-processor.free.beeceptor.com'

  def self.process_transaction(transaction)
    response = post("/transactions", body: { transaction_id: transaction[:tranasction_id] })
    status = response.success? ? :success : :failed
    transaction[:status]= status
    transaction[:amount] = response["amount"]
    transaction[:transaction_reference] = response["transaction_reference"]

    transaction
  end

  def self.bulk_process(transactions)
    response = post("/transactions/bulk_process", body: { transaction_ids: transactions.pluck(:transaction_id) })
    return [] unless response.success?

    trans = []
    transactions.each do |transaction|
      tr = response.detect { |t| t["transaction_id"] == transaction[:transaction_id] }
      if tr.present?
        transaction.merge!(amount: tr["amount"], transaction_reference: tr["transaction_reference"], status: :success)
      else
        transaction.merge!(amount: 0, transaction_reference: nil, status: :falied)
      end

      trans << transaction
    end

    trans
  end
end
