class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.references :take, index: true, null: false
      t.references :question, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :entries, :takes
    add_foreign_key :entries, :questions
  end
end
