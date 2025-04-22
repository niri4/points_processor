class Transaction < ApplicationRecord
  validates :transaction_id, presence: true
  validates :user_id, presence: true
end
