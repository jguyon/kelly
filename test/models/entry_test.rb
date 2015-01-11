require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  test "gets entry status" do
    take = Take.create!(
      guest: guests(:elsa),
      questionnaire: questionnaires(:physics),
      name: "Elsa"
    )
    question = questions(:physics_one)
    entry = Entry.create!(take: take, question: question)

    choices = []
    question.answers.each do |answer|
      choices << Choice.create!(entry: entry, answer: answer)
    end
    assert_equal :incorrect, entry.status

    choices[1].destroy
    assert_equal :correct, entry.status

    choices[2].destroy
    assert_equal :incorrect, entry.status

    choices[0].destroy
    assert_equal :blank, entry.status
  end
end
