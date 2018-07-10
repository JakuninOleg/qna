class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    user ? user_abilities : guest_abilities
  end

  private

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]
    can :destroy, [Question, Answer], user: user
    can :update, [Question, Answer], user: user

    alias_action :vote_up, :vote_down, :reset_vote, to: :vote

    can :vote, [Question, Answer] do |resource|
      !user.author_of?(resource)
    end

    can :destroy, Attachment do |attachment|
      user.author_of?(attachment.attachable)
    end

    can :choose_best, Answer do |answer|
      user.author_of?(answer.question) && !answer.best?
    end
  end

  def guest_abilities
    can :read, [Question, Answer, Comment]
  end
end