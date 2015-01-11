require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  setup do
    @guest = guests(:john)
    @questionnaire = questionnaires(:physics)
    @take = takes(:john_physics)
    authenticate @guest
  end

  test "creates next entry" do
    @take.entries.last.destroy
    assert_difference '@take.entries.count' do
      post :create, questionnaire_id: @questionnaire.token
    end
    assert_redirected_to questionnaire_entry_path(@questionnaire.token)
  end

  test "gets show" do
    get :show, questionnaire_id: @questionnaire.token
    assert_response :success
  end
end
