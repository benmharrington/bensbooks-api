require_relative "../../lib/jwt"

class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create destroy ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      session = user.sessions.create!(
        user_agent: request.user_agent,
        ip_address: request.remote_ip
      )
      access_token = JwtUtil.encode(user.id, session.id)
      refresh_token = user.generate_refresh_token
      user.update!(refresh_token: refresh_token, refresh_token_expires_at: 1.week.from_now)

      cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
      cookies.signed.permanent[:refresh_token] = { value: refresh_token, httponly: true, same_site: :lax }
      cookies.signed.permanent[:access_token] = { value: access_token, httponly: true, same_site: :lax }

      Current.user = user
      Current.session = session

      render json: { access_token: access_token, refresh_token: refresh_token }, status: :ok
    else
      render json: { error: Messages::ERROR[:invalid_credentials] }, status: :unauthorized
    end
  end

  def destroy
    refresh_token = params[:refresh_token] || request.headers["Authorization"]&.split(" ")&.last

    if refresh_token.present?
      user = User.find_by(refresh_token: refresh_token)

      if user&.refresh_token_valid?(refresh_token)
        # Invalidate the refresh token
        user.update!(refresh_token: nil, refresh_token_expires_at: nil)

        # Optionally destroy all sessions for the user
        user.sessions.destroy_all
        terminate_session

        head :no_content
      else
        render json: { error: Messages::ERROR[:refresh_token_invalid] }, status: :unauthorized
      end
    else
      render json: { error: Messages::ERROR[:refresh_token_missing] }, status: :bad_request
    end
  end
end
