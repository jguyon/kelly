require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  setup do
    @guest = guests(:john)
    @questionnaire = questionnaires(:maths)
    authenticate @guest
  end

  def question
    @question ||= questions(:maths_one)
  end

  def question_params
    { title: 'Question title' }
  end

  test "gets index" do
    get :index, questionnaire_id: @questionnaire.id
    assert_includes assigns(:questions), questions(:maths_one)
    assert_not_includes assigns(:questions), questions(:physics_one)
    assert_response :success
  end

  test "gets new" do
    xhr :get, :new, questionnaire_id: @questionnaire.id
    assert_response :success
  end

  test "creates new question" do
    assert_difference '@questionnaire.questions.count' do
      xhr :post, :create, questionnaire_id: @questionnaire.id,
        question: question_params
    end
    assert_response :success
  end

  test "gets edit" do
    xhr :get, :edit, id: question.id
    assert_response :success
  end

  test "updates question" do
    travel 1.day do
      xhr :patch, :update, id: question.id, question: question_params
      assert_equal Time.now, question.reload.updated_at
    end
    assert_response :success
  end

  test "moves question" do
    assert_difference 'question.reload.position' do
      xhr :patch, :move, id: question.id, position: question.position + 1
    end
    assert_response :success
  end

  test "destroys question" do
    assert_difference 'Question.count', -1 do
      xhr :delete, :destroy, id: question.id
    end
    assert_response :success
  end
end
