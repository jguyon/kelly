class QuestionsController < ApplicationController
  before_action :set_questionnaire, only: [:index, :new, :create]
  before_action :set_question, except: [:index, :new, :create]

  def index
    @questions = @questionnaire.questions
  end

  def new
    @question = @questionnaire.questions.build
  end

  def create
    @question = @questionnaire.questions.build(question_params)
    render :new unless @question.save
  end

  def edit
  end

  def update
    render :edit unless @question.update(question_params)
  end

  def move
    @moved_questions = @question.insert_at(params.require(:position))
  end

  def destroy
    @question.destroy
    @moved_questions = @question.moved_items_after_destroy
  end

  private

    def set_questionnaire
      @questionnaire = current_guest.questionnaires.
        not_published.find(params[:questionnaire_id])
    end

    def set_question
      @question = Question.joins(:questionnaire).
        merge(current_guest.questionnaires.not_published).find(params[:id])
    end

    def question_params
      params.require(:question).permit(:title)
    end
end
