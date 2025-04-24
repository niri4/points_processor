class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.string :transaction_id, index: { unique: true }
      t.integer :points, default: 0
      t.string :user_id
      t.integer :status
      t.integer :amount, default: 0
      t.string :transaction_reference

      t.timestamps
    end
  end
end
