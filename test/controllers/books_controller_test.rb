require "test_helper"
require_relative "../../lib/jwt"

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @password = Faker::Internet.password(min_length: 8)
    @user = create(:user, password: @password, password_confirmation: @password)
    @session = @user.sessions.create!(user_agent: "TestAgent", ip_address: "127.0.0.1")
    @access_token = JwtUtil.encode(@user.id, @session.id)
    @expired_token = JwtUtil.encode(@user.id, @session.id, (Time.now - 1.day).to_i)

    @author = create(:author)
    @book = create(:book, author: @author)
  end

  test "should allow unauthenticated access to index" do
    get books_url
    assert_response :success
  end

  test "should allow access to create with valid token" do
    post books_url, params: { book: { title: "New Book", author_id: @author.id } }, headers: { Authorization: "Bearer #{@access_token}" }
    assert_response :success
  end

  test "should return unauthorized without token" do
    post books_url, params: { book: { title: "New Book", author_id: @author.id } }
    assert_response :unauthorized
  end

  test "should return unauthorized with expired token" do
    post books_url, params: { book: { title: "New Book", author_id: @author.id } }, headers: { Authorization: "Bearer #{@expired_token}" }
    assert_response :unauthorized
    json_response = JSON.parse(response.body)
    assert_equal Messages::ERROR[:unauthorized], json_response["error"]
  end
end
