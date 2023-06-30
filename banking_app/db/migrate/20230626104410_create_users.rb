class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :email
      t.string :mobile
      t.integer :customer_id
      t.date :dob
      t.string :password_digest
      t.timestamps
    end
  end
end
