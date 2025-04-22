class Transaction < ApplicationRecord
  enum :status, [:ok, :not_found]
end
