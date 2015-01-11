class Answer < ActiveRecord::Base
  include Sortable

  belongs_to :question, required: true
  has_many :choices, dependent: :destroy
  has_many :entries, through: :choices

  sortable_by :question

  validates :title, presence: true

  scope :correct, -> { where correct: true }
  scope :incorrect, -> { where correct: false }

  def toggle!
    self.correct = !correct
    save!
  end
end
