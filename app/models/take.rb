class Take < ActiveRecord::Base
  belongs_to :guest, required: true
  belongs_to :questionnaire, required: true
  has_many :entries, -> { order :id }, dependent: :destroy

  validates :name, presence: true, length: { in: 2..24, allow_blank: true }

  scope :finished, -> { where.not score: nil }

  def finished?
    !score.nil?
  end

  def current_entry
    entries.last
  end

  # Create and return next entry or calculate score if no questions left
  def next_entry
    if previous_entry = current_entry
      question = previous_entry.question.next_item
    else
      question = questionnaire.questions.first
    end

    if question
      Entry.create!(take: self, question: question)
    else
      calculate_score!
      nil
    end
  end

  private

    def calculate_score!
      self.score = 0
      self.finished_at = Time.now.utc

      entries.includes(:answers, question: :correct_answers).each do |entry|
        if entry.status == :correct
          self.score += questionnaire.points_for_correct_answer
        elsif entry.status == :incorrect
          self.score += questionnaire.points_for_incorrect_answer
        end
      end

      save!
    end
end
