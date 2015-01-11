class QuestionnairesController < ApplicationController
  before_action :set_questionnaire, except: [:new, :create, :show]

  def new
    @questionnaire = current_guest.questionnaires.build
  end

  def create
    @questionnaire = current_guest.questionnaires.build(questionnaire_params)
    if @questionnaire.save
      redirect_to questionnaire_questions_url(@questionnaire)
    else
      render :new
    end
  end

  def edit
    @questionnaire.points_for_correct_answer ||= 2.0
    @questionnaire.points_for_incorrect_answer ||= -1.0
  end

  def update
    @questionnaire.assign_attributes(questionnaire_params)
    if params[:publish] && @questionnaire.publish
      redirect_to questionnaire_path(@questionnaire)
    elsif !params[:publish] && @questionnaire.save
      redirect_to questionnaire_questions_path(@questionnaire)
    else
      render :edit
    end
  end

  def show
    @questionnaire = current_guest.questionnaires.published.find(params[:id])
  end

  private

    def set_questionnaire
      @questionnaire = current_guest.questionnaires.
      not_published.find(params[:id])
    end

    def questionnaire_params
      params.require(:questionnaire).
        permit(:name, :points_for_correct_answer, :points_for_incorrect_answer)
    end
end
