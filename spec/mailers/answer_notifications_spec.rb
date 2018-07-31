require "rails_helper"

RSpec.describe AnswerNotificationsMailer, type: :mailer do
  describe 'notify method' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:mail) { AnswerNotificationsMailer.notify(user, answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Notify')
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq(['from@example.com'])
    end
  end
end
