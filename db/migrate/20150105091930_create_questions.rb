class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :questionnaire, index: true, null: false
      t.text :title, null: false
      t.integer :position, null: false

      t.timestamps null: false
    end
    add_foreign_key :questions, :questionnaires
  end
end
