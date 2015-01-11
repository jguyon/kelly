class CreateQuestionnaires < ActiveRecord::Migration
  def change
    create_table :questionnaires do |t|
      t.references :guest, index: true, null: false
      t.string :token, null: false
      t.string :name, null: false
      t.float :points_for_correct_answer
      t.float :points_for_incorrect_answer
      t.datetime :published_at

      t.timestamps null: false
    end
    add_index :questionnaires, :token, unique: true
    add_foreign_key :questionnaires, :guests
  end
end
