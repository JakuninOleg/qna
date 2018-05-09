class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :by_best, -> { order(best: :desc) }

  def set_best
    best = question.answers.find_by(best: true)

    transaction do
      best.update!(best: false) if best
      update!(best: true)
    end
  end
end

