class Guest < ActiveRecord::Base
  include SecureToken

  has_many :questionnaires, dependent: :destroy
  has_many :takes, dependent: :destroy

  def current_questionnaires
    questionnaires.not_published.order(:id)
  end
end
