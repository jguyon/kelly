class TakesController < ApplicationController
  include Taking

  before_action :ensure_taking, only: :show

  def new
    @take = current_guest.takes.build(questionnaire: @questionnaire)
  end

  def create
    @take = current_guest.takes.
      build(take_params.merge(questionnaire: @questionnaire))
    if @take.save
      @take.next_entry
      redirect_to questionnaire_entry_url(@questionnaire.token)
    else
      render :new
    end
  end

  def show
    @take = current_take
    unless @take.finished?
      redirect_to questionnaire_entry_url(@questionnaire.token)
    end
  end

  private

    def take_params
      params.require(:take).permit(:name)
    end
end
