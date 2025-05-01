require_relative "../../../lib/jwt"

module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private

    def require_authentication
      token = request.headers["Authorization"]&.split(" ")&.last
      payload = JwtUtil.decode(token)
      user = User.find_by(id: payload["user_id"])
      session = Session.find_by(id: payload["session_id"], user_id: user.id)

      if user && session
        Current.user = user
        Current.session = session
      else
        raise ActiveRecord::RecordNotFound
      end
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      Current.user = nil
      Current.session = nil
      render json: { error: Messages::ERROR[:unauthorized] }, status: :unauthorized
    end

    def find_session_by_cookie
      Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
    end

    def start_new_session_for(user)
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session
        cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
      end
    end

    def terminate_session
      Current.session&.destroy
      cookies.delete(:session_id)
    end
end
