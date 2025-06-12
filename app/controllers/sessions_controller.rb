require_relative "../../lib/jwt"

class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create destroy status ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def status
    if authenticated?
      render json: { session: Current.session.as_json(only: [ :id, :user_agent, :ip_address ]), user: Current.user.as_json(only: [ :first_name, :last_name ]) }, status: :ok
    else
      render json: { error: Messages::ERROR[:unauthorized] }, status: :unauthorized
    end
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for(user)

      render json: {}, status: :ok
    else
      render json: { error: Messages::ERROR[:invalid_credentials] }, status: :unauthorized
    end
  end

  def destroy
    terminate_session
  end
end
