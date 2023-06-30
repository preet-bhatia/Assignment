class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :address1
      t.string :district
      t.string :state
      t.string :country
      t.integer :postal_code
      t.integer :customer_id
    end
  end
end
