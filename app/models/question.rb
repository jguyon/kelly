class Question < ActiveRecord::Base
  include Sortable

  belongs_to :questionnaire, required: true
  has_many :answers, -> { order :position }, dependent: :destroy
  has_many :correct_answers, -> { correct }, class_name: 'Answer'
  has_many :entries, dependent: :destroy

  sortable_by :questionnaire

  validates :title, presence: true
end
