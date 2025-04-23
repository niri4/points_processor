# spec/models/transaction_spec.rb
require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it "is valid with valid attributes" do
    expect(build(:transaction)).to be_valid
  end

  it "should have enum as api status as ok and not_found" do
    expect(Transaction::statuses.keys).to eq(["success", "failed"])
  end


  it "should have uniq transaction_id" do
    transaction = create(:transaction)
    expect(build(:transaction, transaction_id: transaction.transaction_id)).to_not be_valid
  end

  it "is invalid without transaction_id" do
    expect(build(:transaction, transaction_id: nil)).to_not be_valid
    expect(build(:transaction, user_id: nil)).to_not be_valid
  end
end
