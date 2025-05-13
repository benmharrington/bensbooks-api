# frozen_string_literal: true

require_relative "../../lib/jwt"

class TokensController < ApplicationController
  allow_unauthenticated_access only: [ :refresh ]

  def refresh
    refresh_token = cookies.signed[:refresh_token]
    user = User.find_by(refresh_token: refresh_token)

    if user&.refresh_token_valid?(cookies.signed[:refresh_token])
      # Generate a new access token and refresh token
      session = user.sessions.create!(
        user_agent: request.user_agent,
        ip_address: request.remote_ip
      )

      new_refresh_token = user.generate_refresh_token
      user.update!(refresh_token: new_refresh_token, refresh_token_expires_at: 1.week.from_now)

      access_token = JwtUtil.encode(user.id, session.id)

      cookies.signed.permanent[:refresh_token] = { value: new_refresh_token, httponly: true, same_site: :lax }
      cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }

      render json: { access_token: access_token, refresh_token: new_refresh_token }, status: :ok
    else
      render json: { error: Messages::ERROR[:refresh_token_invalid] }, status: :unauthorized
    end
  end
end
