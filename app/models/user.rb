class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :synopses
  has_many :ratings
  has_many :synopsis_votes

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def generate_refresh_token
    self.refresh_token = SecureRandom.hex(64)
    self.refresh_token_expires_at = 1.week.from_now
    save!
    refresh_token
  end

  def refresh_token_valid?(token)
    refresh_token == token && refresh_token_expires_at > Time.current
  end
end
