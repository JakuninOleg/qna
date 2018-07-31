# Preview all emails at http://localhost:3000/rails/mailers/answer_notifications
class AnswerNotificationsPreview < ActionMailer::Preview
  def notify
    AnswerNotificationsMailer.notify(User.first, Answer.first)
  end
end
