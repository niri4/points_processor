FactoryBot.define do
  factory :transaction do
    transaction_id { SecureRandom.hex(4) }
    points { rand(1..100) }
    user_id { "user_#{rand(1..10)}" }
  end
end
