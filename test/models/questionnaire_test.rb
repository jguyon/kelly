require 'test_helper'

class QuestionnaireTest < ActiveSupport::TestCase
  test "publishes questionnaire" do
    questionnaire = questionnaires(:maths)

    assert_not questionnaire.publish
    assert_nil questionnaire.published_at

    questionnaire.points_for_correct_answer = 2.0
    questionnaire.points_for_incorrect_answer = -1.0
    assert questionnaire.publish
    assert_not_nil questionnaire.published_at
  end
end
