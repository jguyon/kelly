class CreateTakes < ActiveRecord::Migration
  def change
    create_table :takes do |t|
      t.references :guest, index: true, null: false
      t.references :questionnaire, index: true, null: false
      t.string :name, null: false
      t.datetime :finished_at
      t.float :score

      t.timestamps null: false
    end
    add_foreign_key :takes, :guests
    add_foreign_key :takes, :questionnaires
  end
end
