class CreateLoanAccountInfo < ActiveRecord::Migration[5.0]
  def change
    create_table :loan_account_infos do |t|
        t.integer :loan_type
        t.integer :duration
        t.integer :amount
        t.string :account_number
        t.timestamps
    end
  end
end
