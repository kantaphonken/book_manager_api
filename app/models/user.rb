class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true, allow_nil: true

  def after_database_authentication
    self.update_column(:authentication_token, generate_authentication_token)

  end

  def after_token_authentication
    self.update_column(:authentication_token, nil)
  end

  def token_expired?
    token_expires_at && token_expires_at <= DateTime.now
  end

  private

  def generate_authentication_token
    loop do
      token = SecureRandom.urlsafe_base64
      break token unless User.exists?(authentication_token: token)
    end
  end

  def ensure_authentication_token_and_expiry
    # If token is not set or expired, generate a new one
    if !authentication_token || token_expired?
      self.authentication_token = generate_authentication_token
      self.token_expires_at = 24.hours.from_now
    end
  end
end
