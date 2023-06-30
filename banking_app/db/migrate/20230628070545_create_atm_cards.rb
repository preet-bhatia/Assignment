class CreateAtmCards < ActiveRecord::Migration[5.0]
  def change
    create_table :atm_cards do |t|
      t.string :card_number
      t.integer :cvv
      t.string :expiry_date
      t.string :account_number
      t.timestamps
    end
  end
end
