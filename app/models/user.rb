class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:vkontakte, :twitter]

  has_many :questions
  has_many :answers
  has_many :comments
  has_many :ratings
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def author_of?(resource)
    resource.user_id == id
  end

  def email_temp?
    email =~ /@email.temp/
  end

  def admin?
    is_a?(Admin)
  end

  def subscribed?(question)
    self.subscriptions.exists?(question: question.id)
  end

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info.email
    user = User.where(email: email).first

    unless user
      email ||= "#{Devise.friendly_token[0, 10]}@email.temp"
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)

      user.skip_confirmation!
      user.save
    end

    user.authorizations.create(provider: auth.provider, uid: auth.uid)
    user
  end
end
