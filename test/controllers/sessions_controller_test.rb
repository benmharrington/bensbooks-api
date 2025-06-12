require "test_helper"
require_relative "../../lib/jwt"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @password = Faker::Internet.password(min_length: 8)
    @user = create(:user, password: @password, password_confirmation: @password)
  end

  test "should create a session with valid credentials" do
    post "/sessions", params: { email_address: @user.email_address, password: @password }
    jar = ActionDispatch::Cookies::CookieJar.build(request, response.cookies)

    assert_response :ok

    assert jar.encrypted[:session_id].present?
  end

  test "should not create a session with invalid credentials" do
    post "/sessions", params: { email_address: @user.email_address, password: "wrongpassword" }

    assert_response :unauthorized
    json_response = JSON.parse(response.body)
    assert_equal Messages::ERROR[:invalid_credentials], json_response["error"]
  end

  test "should log out and clear session cookies" do
    post "/sessions", params: { email_address: @user.email_address, password: @password }
    jar = ActionDispatch::Cookies::CookieJar.build(request, response.cookies)

    assert_response :ok
    assert jar.encrypted[:session_id].present?

    delete "/sessions"

    jar = ActionDispatch::Cookies::CookieJar.build(request, response.cookies)

    assert_response :no_content
    assert jar.encrypted[:session_id].nil?
  end
end
