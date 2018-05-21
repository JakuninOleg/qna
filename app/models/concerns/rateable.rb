module Rateable
  extend ActiveSupport::Concern

  included do
    has_many :ratings, as: :rateable, dependent: :destroy
  end

  def vote_up(user)
    ratings.create!(vote: 1, user: user)
  end

  def vote_down(user)
    ratings.create!(vote: -1, user: user)
  end

  def reset_vote(user)
    ratings.where(user: user).delete_all
  end

  def votes
    ratings.sum(:vote)
  end

  def voted?(user)
    ratings.exists?(user: user)
  end
end
