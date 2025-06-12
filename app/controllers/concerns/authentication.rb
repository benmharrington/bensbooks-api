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
    if !authenticated?
      render json: { error: Messages::ERROR[:unauthorized] }, status: :unauthorized
    end
  end

  def authenticated?
    find_session_by_cookie
  end

  def find_session_by_cookie
    if cookies.encrypted[:session_id]
      session = Session.find_by(id: cookies.encrypted[:session_id])
      Current.session = session
      session
    else
      Rails.logger.debug "No session_id cookie found."
      nil
    end
  end

  def start_new_session_for(user)
    user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
      cookies.encrypted[:session_id] = { value: session.id, httponly: true, same_site: :lax }
    end
  end

  def terminate_session
    find_session_by_cookie
    if Current.user
      Current.user.sessions.destroy_all
    else
      Rails.logger.debug "No current user to destroy session for."
    end
    cookies&.delete(:session_id)
  end
end
