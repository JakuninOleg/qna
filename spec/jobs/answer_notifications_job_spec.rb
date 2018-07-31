require 'rails_helper'

RSpec.describe AnswerNotificationsJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  it 'sends an email with answer to subscribers' do
    question.subscriptions.each do |subscription|
      expect(AnswerNotificationsMailer).to receive(:notify).with(subscription.user, answer).and_call_original
    end

    AnswerNotificationsJob.perform_now(answer)
  end
end
