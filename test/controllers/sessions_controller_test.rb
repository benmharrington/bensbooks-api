require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @password = Faker::Internet.password(min_length: 8)
    @user = create(:user, password: @password, password_confirmation: @password)
    @session = @user.sessions.create!(user_agent: "TestAgent", ip_address: "127.0.0.1")
    Current.session = @session
    Current.user = @user

    @refresh_token = @user.generate_refresh_token

    cookies[:session_id] = @session.id
  end

  test "should return access and refresh tokens with valid credentials" do
    post session_url, params: { email_address: @user.email_address, password: @password }
    assert_response :success
    json_response = JSON.parse(response.body)
    assert json_response["access_token"]
    assert json_response["refresh_token"]
  end

  test "should return unauthorized with invalid credentials" do
    post session_url, params: { email_address: @user.email_address, password: "wrongpassword" }
    assert_response :unauthorized
    json_response = JSON.parse(response.body)
    assert_equal Messages::ERROR[:invalid_credentials], json_response["error"]
  end
  test "should invalidate refresh token on logout" do
    delete session_url, params: { refresh_token: @refresh_token }
    assert_response :no_content

    # Verify that the refresh token is invalidated
    assert_nil @user.reload.refresh_token
  end

  test "should return unauthorized with invalid refresh token" do
    delete session_url, params: { refresh_token: "invalid_token" }
    assert_response :unauthorized
    json_response = JSON.parse(response.body)
    assert_equal Messages::ERROR[:refresh_token_invalid], json_response["error"]
  end

  test "should return bad request if refresh token is missing" do
    delete session_url
    assert_response :bad_request
    json_response = JSON.parse(response.body)
    assert_equal Messages::ERROR[:refresh_token_missing], json_response["error"]
  end
end
