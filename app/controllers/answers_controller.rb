class AnswersController < ApplicationController
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, except: [:new, :create]

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.build(answer_params)
    render :new unless @answer.save
  end

  def edit
  end

  def update
    render :edit unless @answer.update(answer_params)
  end

  def move
    @moved_answers = @answer.insert_at(params.require(:position))
  end

  def toggle
    @answer.toggle!
  end

  def destroy
    @answer.destroy
    @moved_answers = @answer.moved_items_after_destroy
  end

  private

    def set_question
      @question = Question.joins(:questionnaire).
        merge(current_guest.questionnaires.not_published).
        find(params[:question_id])
    end

    def set_answer
      @answer = Answer.joins(question: :questionnaire).
        merge(current_guest.questionnaires.not_published).
        find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:title)
    end
end
