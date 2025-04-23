require 'rails_helper'

RSpec.describe "Transactions API", type: :request do
  describe "POST /api/v1/transactions/single" do
    it "fetches and stores a single transaction" do
      transaction = {
        transaction_id: 'abc123',
        points: 100,
        user_id: 'user_9'
      }

      stub_request(:post, "http://points-processor.free.beeceptor.com/transactions")
        .to_return(body: transaction.to_json, headers: { 'Content-Type' => 'application/json' })

      post '/api/v1/transactions/single', params: transaction

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["transaction_id"]).to eq("abc123")
    end

    it "returns error  if already exist single transaction" do
      transaction = {
        transaction_id: 'abc123',
        points: 100,
        user_id: 'user_9'
      }

      create(:transaction, transaction)

      stub_request(:post, "http://points-processor.free.beeceptor.com/transactions")
        .to_return(body: transaction.to_json, headers: { 'Content-Type' => 'application/json' })

      post '/api/v1/transactions/single', params: transaction

      expect(response).not_to have_http_status(:success)
    end
  end

  describe "POST /api/v1/transactions/bulk" do
    it "fetches and stores multiple transactions" do
      transactions = [
        { transaction_id: 't1', points: 30, user_id: 'u1' },
        { transaction_id: 't2', points: 70, user_id: 'u2' }
      ]

      stub_request(:post, "http://points-processor.free.beeceptor.com/transactions/bulk_process")
        .to_return(body: transactions.to_json, headers: { 'Content-Type' => 'application/json' })

      post '/api/v1/transactions/bulk', params: { transactions: transactions }

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["processed_count"]).to eq(2)
    end
  end
end
