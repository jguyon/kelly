class EntriesController < ApplicationController
  include Taking

  before_action :ensure_taking
  before_action :ensure_not_finished

  def create
    if current_take.next_entry
      redirect_to questionnaire_entry_url(@questionnaire.token)
    else
      redirect_to questionnaire_take_url(@questionnaire.token)
    end
  end

  def show
    if current_take.finished?
      redirect_to questionnaire_take_url(@questionnaire.token)
    else
      @entry = current_take.current_entry
    end
  end
end
