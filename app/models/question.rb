class Question < ApplicationRecord
  include Rateable
  include Commentable

  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  has_many :subscriptions, dependent: :destroy

  validates :title, :body, presence: true

  after_create :subscribe_author

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  def subscribe_author
    subscriptions.create(user: user)
  end
end
