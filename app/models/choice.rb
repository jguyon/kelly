class Choice < ActiveRecord::Base
  belongs_to :entry, required: true, touch: true
  belongs_to :answer, required: true

  validates :answer, uniqueness: { scope: :entry }
end
