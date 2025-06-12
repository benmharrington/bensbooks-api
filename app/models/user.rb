class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :synopses
  has_many :ratings
  has_many :synopsis_votes

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
