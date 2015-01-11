module Taking
  extend ActiveSupport::Concern

  included do
    helper_method :current_take
    before_action :set_questionnaire

    rescue_from TakeNotFound do
      redirect_to new_questionnaire_take_url(@questionnaire.token)
    end

    rescue_from FinishedTake do
      redirect_to questionnaire_take_url(@questionnaire.token)
    end
  end

  class TakeNotFound < StandardError
  end

  class FinishedTake < StandardError
  end

  private

    def set_questionnaire
      @questionnaire = Questionnaire.published.
        find_by!(token: params[:questionnaire_id])
    end

    def current_take
      @current_take ||= current_guest.takes.order(id: :desc).
        find_by(questionnaire_id: @questionnaire.id)
    end

    def ensure_taking
      raise TakeNotFound unless current_take
    end

    def ensure_not_finished
      raise FinishedTake if current_take.finished?
    end
end
