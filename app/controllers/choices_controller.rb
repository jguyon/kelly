class ChoicesController < ApplicationController
  include Taking

  before_action :ensure_taking
  before_action :ensure_not_finished

  def create
    @choice = current_take.current_entry.choices.build(choice_params)
    render nothing: true unless @choice.save
  end

  def destroy
    @choice = current_take.current_entry.choices.find(params[:id])
    @choice.destroy
  end

  private

    def choice_params
      params.require(:choice).permit(:answer_id)
    end
end
