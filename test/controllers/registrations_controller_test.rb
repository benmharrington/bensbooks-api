require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @password = Faker::Internet.password(min_length: 8)
    @user_params = {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email_address: Faker::Internet.email,
      password: @password,
      password_confirmation: @password
    }
  end

  test "should create user with valid params" do
    post "/registrations", params: { user: @user_params }
    assert_response :created

    json_response = JSON.parse(response.body)
    assert json_response["user"]["first_name"].present?

    user = User.find_by(email_address: @user_params[:email_address])
    assert user.present?
  end

  test "should not create user with invalid params" do
    post "/registrations", params: { user: @user_params.merge(email_address: "") }
    assert_response :unprocessable_entity

    json_response = JSON.parse(response.body)
    assert json_response["errors"].present?
    assert_includes json_response["errors"], "Email address can't be blank"
  end

  test "should not create user with duplicate email" do
    post "/registrations", params: { user: @user_params }
    assert_response :created

    post "/registrations", params: { user: @user_params }
    assert_response :unprocessable_entity

    json_response = JSON.parse(response.body)
    assert json_response["errors"].present?
    assert_includes json_response["errors"], "Email address has already been taken"
  end

  test "should normalize email address" do
    normalized_email = @user_params[:email_address].strip.downcase
    post "/registrations", params: { user: @user_params.merge(email_address: "  #{normalized_email}  ") }
    assert_response :created

    json_response = JSON.parse(response.body)
    assert json_response["user"]["first_name"].present?

    user = User.find_by(email_address: @user_params[:email_address])
    assert user.present?
  end

  test "should start new session after registration" do
    post "/registrations", params: { user: @user_params }
    assert_response :created

    jar = ActionDispatch::Cookies::CookieJar.build(request, response.cookies)
    assert jar.encrypted[:session_id].present?

    json_response = JSON.parse(response.body)
    assert json_response["user"]["first_name"].present?

    user = User.find_by(email_address: @user_params[:email_address])
    assert user.present?
  end
end
