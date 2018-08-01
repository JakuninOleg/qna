require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let(:user) { create :user }
    let(:mail) { DailyMailer.digest(user) }
    let(:questions) { create_list(:question, 2, user: user) }
    let(:questions_2) { create_list(:question, 2, user: user, created_at: 3.days.ago) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders questions created through past day" do
      questions.each do |question|
        expect(mail.body.encoded).to match(question.title)
      end
    end

    it "doesn't send notifications about questions created earlier" do
      questions_2.each do |question|
        expect(mail.body.encoded).to_not match(question.title)
      end
    end
  end
end
