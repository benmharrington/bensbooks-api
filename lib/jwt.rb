# frozen_string_literal: true

require "jwt"

# TODO: currently unused - utilize in the future for JWT-based authentication
module JwtUtil
  def self.secret_key
    Rails.application.credentials.secret_key_base
  end

  def self.encode(user_id, session_id, exp = 15.minutes.from_now.to_i)
    JWT.encode({ user_id: user_id, session_id: session_id, exp: exp }, secret_key)
  end

  def self.decode(token)
    body = JWT.decode(token, secret_key, true, { algorithm: "HS256", verify_exp: true })[0]
    HashWithIndifferentAccess.new(body)
  rescue JWT::ExpiredSignature
    raise JWT::DecodeError, "Token has expired"
  rescue JWT::DecodeError
    Rails.logger.debug "JWT::DecodeError: Invalid token"
    raise
  end
end
