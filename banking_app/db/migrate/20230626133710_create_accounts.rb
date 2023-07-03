class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :account_number
      t.integer :account_type
      t.float :balance
      t.integer :customer_id
      t.datetime :created_at
    end
  end
end
