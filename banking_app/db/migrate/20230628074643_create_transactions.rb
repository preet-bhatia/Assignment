class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.float :amount
      t.string :account_number
      t.integer :transaction_type
      t.float :current_balance
      t.string :account_related
      t.datetime :created_at
    end
  end
end
