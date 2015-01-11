class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :question, index: true, null: false
      t.text :title, null: false
      t.boolean :correct, null: false, default: false
      t.integer :position, null: false

      t.timestamps null: false
    end
    add_foreign_key :answers, :questions
  end
end
