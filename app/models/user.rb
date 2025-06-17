class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :synopses
  has_many :ratings
  has_many :synopsis_votes

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :first_name, presence: true, length: { minimum: 1 }
  validates :password, presence: true, length: { minimum: 8 }, confirmation: true
  validates :email_address, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
end
