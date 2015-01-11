require 'test_helper'

class ChoicesControllerTest < ActionController::TestCase
  setup do
    @guest = guests(:john)
    @questionnaire = questionnaires(:physics)
    @entry = entries(:john_physics_three)
    authenticate @guest
  end

  test "creates new choice" do
    @entry.choices.destroy_all
    assert_difference '@entry.choices.count' do
      xhr :post, :create, questionnaire_id: @questionnaire.token,
        choice: { answer_id: answers(:physics_three_correct).id }
    end
    assert_response :success
  end

  test "destroys choice" do
    assert_difference '@entry.choices.count', -1 do
      xhr :delete, :destroy, questionnaire_id: @questionnaire.token,
        id: choices(:john_physics_three_correct)
    end
    assert_response :success
  end
end
