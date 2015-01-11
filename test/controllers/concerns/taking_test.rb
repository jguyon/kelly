require 'test_helper'

class TakingController < ApplicationController
  include Taking

  before_action :ensure_taking, only: :test_ensure_taking
  before_action :ensure_not_finished, only: :test_ensure_not_finished

  def test_questionnaire
    render nothing: true
  end

  def test_current_take
    @result = current_take
    render nothing: true
  end

  def test_ensure_taking
    render nothing: true
  end

  def test_ensure_not_finished
    render nothing: true
  end
end

class TakingTest < ActionController::TestCase
  tests TakingController

  def with_dummy_routing
    with_routing do |set|
      set.draw do
        resources :questionnaires, only: [] do
          resource :take, only: [:new, :show]

          controller :taking do
            get :test_questionnaire
            get :test_current_take
            get :test_ensure_taking
            get :test_ensure_not_finished
          end
        end
      end

      yield
    end
  end

  setup do
    @guest = guests(:john)
    @questionnaire = questionnaires(:physics)
    authenticate @guest
  end

  test "assigns questionnaire" do
    with_dummy_routing do
      get :test_questionnaire, questionnaire_id: @questionnaire.token
      assert_equal @questionnaire, assigns(:questionnaire)
    end
  end

  test "gets current take" do
    with_dummy_routing do
      take = takes(:john_physics)
      get :test_current_take, questionnaire_id: @questionnaire.token
      assert_equal take, assigns(:result)
    end
  end

  test "ensures guest is taking questionnaire" do
    with_dummy_routing do
      takes(:john_physics).destroy
      get :test_ensure_taking, questionnaire_id: @questionnaire.token
      assert_redirected_to new_questionnaire_take_path
    end
  end

  test "ensures guest has finished questionnaire" do
    with_dummy_routing do
      takes(:john_physics).next_entry
      get :test_ensure_not_finished, questionnaire_id: @questionnaire.token
      assert_redirected_to questionnaire_take_path(@questionnaire.token)
    end
  end
end
