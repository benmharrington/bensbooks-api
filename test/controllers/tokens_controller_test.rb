require "test_helper"

class TokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, password: "password123", password_confirmation: "password123")
    @refresh_token = @user.generate_refresh_token
  end

  test "should return new access and refresh tokens with valid refresh token" do
    post tokens_refresh_url, params: { refresh_token: @refresh_token }
    assert_response :success
    json_response = JSON.parse(response.body)
    assert json_response["access_token"]
    assert json_response["refresh_token"]
  end

  test "should return unauthorized with invalid refresh token" do
    post tokens_refresh_url, params: { refresh_token: "invalid_token" }
    assert_response :unauthorized
    json_response = JSON.parse(response.body)
    assert_equal Messages::ERROR[:refresh_token_invalid], json_response["error"]
  end
end
