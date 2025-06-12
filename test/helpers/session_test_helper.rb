module SessionTestHelper
  # TODO: include in all tests that require session management
  def sign_in_as(user)
    session = user.sessions.create!
    Current.session = session

    ActionDispatch::TestRequest.create.cookie_jar.tap do |jar|
      jar.encrypted[:session_id] = session.id
      cookies[:session_id] = jar[:session_id]
    end
  end

  def sign_out
    cookies.delete(:session_id)
  end
end
