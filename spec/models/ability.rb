require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:user_2) { create :user }
    let(:question) { create :question, user: user }
    let(:question_2) { create :question, user: user_2 }
    let(:question_attachment) { create :attachment, attachable: question }
    let(:question_attachment_2) { create :attachment, attachable: question_2 }
    let(:answer) { create :answer, user: user, question: question }
    let(:answer_2) { create :answer, user: user_2, question: question_2 }
    let(:answer_attachment) { create :attachment, attachable: answer }
    let(:answer_attachment_2) { create :attachment, attachable: answer_2 }

    it { should_not be_able_to :manage, :all }

    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :destroy, question, user: user }
      it { should_not be_able_to :destroy, question_2, user: user }
      it { should be_able_to :update, question, user: user }
      it { should_not be_able_to :update, question_2, user: user }
      it { should_not be_able_to [:vote_up, :reset_vote, :vote_down], question, user: user }
      it { should be_able_to [:vote_up, :reset_vote, :vote_down], question_2, user: user }
      it { should be_able_to :destroy, question_attachment, user: user }
      it { should_not be_able_to :destroy, question_attachment_2, user: user }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :destroy, answer, user: user }
      it { should_not be_able_to :destroy, answer_2, user: user }
      it { should be_able_to :update, answer, user: user }
      it { should_not be_able_to :update, answer_2, user: user }
      it { should_not be_able_to [:vote_up, :reset_vote, :vote_down], answer, user: user }
      it { should be_able_to [:vote_up, :reset_vote, :vote_down], answer_2, user: user }
      it { should be_able_to :destroy, answer_attachment, user: user }
      it { should_not be_able_to :destroy, answer_attachment_2, user: user }
      it { should be_able_to :destroy, answer_attachment, user: user }
      it { should_not be_able_to :destroy, answer_attachment_2, user: user }
      it { should_not be_able_to :set_best, answer_2, user: user }
      it { should be_able_to :set_best, answer, user: user }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment }
    end
  end
end
