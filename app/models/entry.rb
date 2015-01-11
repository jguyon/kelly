class Entry < ActiveRecord::Base
  belongs_to :take, required: true
  belongs_to :question, required: true
  has_many :choices, dependent: :destroy
  has_many :answers, through: :choices

  validates :question, uniqueness: { scope: :take }

  def choice_for(answer)
    choices.find_by(answer: answer)
  end

  def status
    if answer_ids.sort == question.correct_answer_ids.sort
      :correct
    elsif answer_ids.empty?
      :blank
    else
      :incorrect
    end
  end
end
