class Rating < ApplicationRecord
  belongs_to :rateable, polymorphic: true
  belongs_to :user

  validates :vote, presence: true, inclusion: [1, -1]
  validates_uniqueness_of :user_id, scope: [:rateable_id, :rateable_type]
end
