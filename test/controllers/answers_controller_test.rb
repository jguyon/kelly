require 'test_helper'

class AnswersControllerTest < ActionController::TestCase
  setup do
    @guest = guests(:john)
    @question = questions(:maths_one)
    authenticate @guest
  end

  def answer
    @answer ||= answers(:maths_one_incorrect)
  end

  def answer_params
    { title: 'Answer title' }
  end

  test "gets new" do
    xhr :get, :new, question_id: @question.id
    assert_response :success
  end

  test "creates new answer" do
    assert_difference '@question.answers.count' do
      xhr :post, :create, question_id: @question.id, answer: answer_params
    end
    assert_response :success
  end

  test "gets edit" do
    xhr :get, :edit, id: answer.id
    assert_response :success
  end

  test "updates answer" do
    travel 1.day do
      xhr :patch, :update, id: answer.id, answer: answer_params
      assert_equal Time.now, answer.reload.updated_at
    end
    assert_response :success
  end

  test "moves answer" do
    assert_difference 'answer.reload.position' do
      xhr :patch, :move, id: answer.id, position: answer.position + 1
    end
    assert_response :success
  end

  test "toggles answer" do
    xhr :patch, :toggle, id: answer.id
    assert answer.reload.correct
    assert_response :success
  end

  test "destroys answer" do
    assert_difference 'Answer.count', -1 do
      xhr :delete, :destroy, id: answer.id
    end
    assert_response :success
  end
end
