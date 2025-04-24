require 'rails_helper'

RSpec.describe ExternalTransactionService do
  describe ".process_transaction" do
    it "returns parsed transaction data" do
      transaction = { transaction_id: 'abc123', amount: 50, transaction_reference: 'user_1' }
      stub_request(:post, "http://points-processor.free.beeceptor.com/transactions")
        .to_return(body: transaction.to_json, headers: { 'Content-Type' => 'application/json' })

      result = ExternalTransactionService.process_transaction({
        transaction_id: 'abc123',
        points: 50,
        user_id: 'user_1',
      })

      expect(result).to eq({
        transaction_id: 'abc123',
        amount: 50,
        points: 50,
        transaction_reference: 'user_1',
        user_id: "user_1",
        status: :success
      })
    end

    it "returns error parsed transaction data" do
      transaction = { transaction_id: 'abc123', points: 50, amount: nil,  user_id: 'user_1', transaction_reference: nil }
      stub_request(:post, "http://points-processor.free.beeceptor.com/transactions")
        .to_return(body: '', headers: { 'Content-Type' => 'application/json' }, status: :bad_request)

      result = ExternalTransactionService.process_transaction({
        transaction_id: 'abc123',
        points: 50,
        user_id: 'user_1',
      })
      transaction[:status] =:failed

      expect(result).to eq(transaction)
    end
  end

  describe ".bulk_process" do
    it "returns parsed transaction data" do
      stub_request(:post, "http://points-processor.free.beeceptor.com/transactions/bulk_process")
        .to_return(body: [{
          transaction_id: 'abc123',
          amount: 50,
          transaction_reference: 'user_1',
        }].to_json, headers: { 'Content-Type' => 'application/json' })

      result = ExternalTransactionService.bulk_process([{
          transaction_id: 'abc123',
          points: 50,
          user_id: 'user_1',
        }])

      expect(result).to eq([{ amount: 50, points: 50, status: :success, transaction_id: "abc123", transaction_reference: "user_1", user_id: "user_1"}])
    end

    it "returns error parsed transaction data" do
      stub_request(:post, "http://points-processor.free.beeceptor.com/transactions/bulk_process")
        .to_return(body: '', headers: { 'Content-Type' => 'application/json' }, status: :bad_request)

      result = ExternalTransactionService.bulk_process([{
          transaction_id: 'abc123',
          points: 50,
          user_id: 'user_1',
        }])

      expect(result).to eq([])
    end
  end
end
