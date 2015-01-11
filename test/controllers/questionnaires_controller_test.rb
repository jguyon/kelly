require 'test_helper'

class QuestionnairesControllerTest < ActionController::TestCase
  setup do
    @guest = guests(:john)
    authenticate @guest
  end

  def questionnaire
    @questionnaire = questionnaires(:maths)
  end

  def questionnaire_params
    {
      points_for_correct_answer: 2,
      points_for_incorrect_answer: -1
    }
  end

  test "gets new" do
    get :new
    assert_response :success
  end

  test "creates new questionnaire" do
    assert_difference '@guest.questionnaires.count' do
      post :create, questionnaire: { name: 'New questionnaire' }
    end
    assert_redirected_to questionnaire_questions_path(Questionnaire.last)
  end

  test "gets edit" do
    get :edit, id: questionnaire.id
    assert_response :success
  end

  test "updates questionnaire" do
    travel 1.day do
      patch :update, id: questionnaire.id, questionnaire: questionnaire_params
      assert_equal Time.now, questionnaire.reload.updated_at
    end
    assert_redirected_to questionnaire_questions_path(questionnaire)
  end

  test "publishes questionnaire" do
    patch :update, id: questionnaire.id, publish: true,
      questionnaire: questionnaire_params
    assert questionnaire.reload.published?
    assert_redirected_to questionnaire_path(questionnaire)
  end

  test "gets show" do
    questionnaire.assign_attributes(questionnaire_params)
    questionnaire.publish
    get :show, id: questionnaire.id
    assert_response :success
  end
end
