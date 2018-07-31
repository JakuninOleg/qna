# Preview all emails at http://localhost:3000/rails/mailers/daily_mailer
class DailyMailerPreview < ActionMailer::Preview
  def digest
    DailyMailerMailer.digest(User.first)
  end
end
