class CreateChoices < ActiveRecord::Migration
  def change
    create_table :choices do |t|
      t.references :entry, index: true, null: false
      t.references :answer, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :choices, :entries
    add_foreign_key :choices, :answers
  end
end
