class ExternalTransactionService
  include HTTParty
  base_uri 'points-processor.free.beeceptor.com'

  def self.process_transaction(transaction)
    response = post("/transactions", body: { transaction: transaction })
    status = response.success? ? :success : :failed
    transaction[:status]= status

    transaction
  end

  def self.bulk_process(transactions)
    response = post("/transactions/bulk_process", body: { transactions: transactions })
    return [] unless response.success?

    trans = []
    transactions.each do |transaction|
      tr = response.detect { |t| t["transaction_id"] == transaction[:transaction_id] }
      transaction.merge!(status: tr.present? ? :success : :failed)
      trans << transaction
    end

    trans
  end
end
