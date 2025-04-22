# spec/services/external_transaction_service_spec.rb
require 'rails_helper'
require 'webmock/rspec'

RSpec.describe ExternalTransactionService do
  describe ".fetch_transaction" do
    it "returns parsed transaction data" do
      stub_request(:get, "http://points-processor.free.beeceptor.com/transactions/abc123")
        .to_return(body: {
          transaction_id: 'abc123',
          points: 50,
          user_id: 'user_1',
        }.to_json, headers: { 'Content-Type' => 'application/json' })

      result = ExternalTransactionService.fetch_transaction("abc123")

      expect(result).to eq({
        transaction_id: 'abc123',
        points: 50,
        user_id: 'user_1'
      })
    end

    it "returns error parsed transaction data" do
      stub_request(:get, "http://points-processor.free.beeceptor.com/transactions/invalid")
        .to_return(body: '', headers: { 'Content-Type' => 'application/json' }, status: :bad_request)

      result = ExternalTransactionService.fetch_transaction("invalid")

      expect(result).to eq({
        transaction_id: "invalid",
        points: 0,
        user_id: nil
      })
    end
  end

  describe ".fetch_bulk" do
    it "returns parsed transaction data" do
      stub_request(:get, "http://points-processor.free.beeceptor.com/transactions/bulk")
        .to_return(body: { transactions: [{
          transaction_id: 'abc123',
          points: 50,
          user_id: 'user_1',
        }]}.to_json, headers: { 'Content-Type' => 'application/json' })

      result = ExternalTransactionService.fetch_bulk

      expect(result).to eq([{
        transaction_id: 'abc123',
        points: 50,
        user_id: 'user_1'
      }].as_json)
    end

    it "returns error parsed transaction data" do
      stub_request(:get, "http://points-processor.free.beeceptor.com/transactions/bulk")
        .to_return(body: '', headers: { 'Content-Type' => 'application/json' }, status: :bad_request)

      result = ExternalTransactionService.fetch_bulk

      expect(result).to eq([{
        transaction_id: nil,
        points: 0,
        user_id: nil
      }])
    end
  end
end
