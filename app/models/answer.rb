class Answer < ApplicationRecord
  include Rateable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user

  has_many :attachments, as: :attachable

  validates :body, presence: true

  after_create :notify_subscribers

  scope :by_best, -> { order(best: :desc) }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  def set_best
    best = question.answers.find_by(best: true)

    transaction do
      best.update!(best: false) if best
      update!(best: true)
    end
  end

  def notify_subscribers
    AnswerNotificationsJob.perform_later(self)
  end
end

