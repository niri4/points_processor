class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.string :transaction_id
      t.integer :points, default: 0
      t.string :user_id
      t.integer :status

      t.timestamps
    end
  end
end
