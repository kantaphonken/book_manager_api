class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true, allow_nil: true

  def after_database_authentication
    self.update(authentication_token: generate_authentication_token, token_expires_at: 24.hours.from_now)
  end

  def after_token_authentication
    self.update(authentication_token: nil, token_expires_at: nil)
  end

  def token_expired?
    token_expires_at && token_expires_at <= DateTime.now
  end

  private

  def generate_authentication_token
    loop do
      token = SecureRandom.uuid
      break token unless User.exists?(authentication_token: token)
    end
  end
end
