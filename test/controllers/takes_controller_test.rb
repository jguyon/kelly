require 'test_helper'

class TakesControllerTest < ActionController::TestCase
  setup do
    @guest = guests(:john)
    @questionnaire = questionnaires(:physics)
    authenticate @guest
  end

  test "gets new" do
    get :new, questionnaire_id: @questionnaire.token
    assert_response :success
  end

  test "creates new take" do
    assert_difference '@questionnaire.takes.count' do
      post :create, questionnaire_id: @questionnaire.token,
        take: { name: 'Elsa' }
    end
    take = Take.last
    assert_equal @guest, take.guest
    assert_equal 1, take.entries.count
    assert_redirected_to questionnaire_entry_path(@questionnaire.token)
  end

  test "gets show" do
    takes(:john_physics).next_entry
    get :show, questionnaire_id: @questionnaire.token
    assert_response :success
  end
end
