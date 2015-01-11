class Questionnaire < ActiveRecord::Base
  include SecureToken

  belongs_to :guest, required: true
  has_many :questions, -> { order :position }, dependent: :destroy
  has_many :takes, dependent: :destroy

  validates :name, presence: true, length: { in: 2..24, allow_blank: true }
  validates :points_for_correct_answer, :points_for_incorrect_answer,
    presence: { if: :published? }
  validates :points_for_correct_answer,
    numericality: { greater_than: 0, allow_blank: true }
  validates :points_for_incorrect_answer,
    numericality: { less_than_or_equal_to: 0, allow_blank: true }

  scope :published, -> { where.not published_at: nil }
  scope :not_published, -> { where published_at: nil }

  def published?
    !published_at.nil?
  end

  def publish
    self.published_at = Time.now.utc
    if save
      true
    else
      self.published_at = nil
      false
    end
  end

  def max_score
    questions.size * points_for_correct_answer
  end
end
