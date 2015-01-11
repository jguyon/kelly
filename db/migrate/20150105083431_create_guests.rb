class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.string :token, null: false

      t.timestamps null: false
    end
    add_index :guests, :token, unique: true
  end
end
