class Transaction < ApplicationRecord
  enum :status, [:success, :failed]
  validates :transaction_id, presence: true, uniqueness: true
  validates :user_id, presence: true
end
