class CreateKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :keys do |t|
      t.string :key_id
      t.string :status
      t.datetime :last_alive_at 
      t.datetime :timestamp
    end
  end
end
