require "test_helper"
require_relative "../../lib/jwt"
require_relative "../helpers/session_test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  include SessionTestHelper

  setup do
    @password = Faker::Internet.password(min_length: 8)
    @user = create(:user, password: @password, password_confirmation: @password)

    @author = create(:author)
    @book = create(:book, author: @author)
  end

  test "should allow unauthenticated access to index" do
    get books_url
    assert_response :success
  end

  test "should allow access to create with valid session" do
    sign_in_as(@user)

    post books_url, params: { book: { title: "New Book", author_id: @author.id } }
    assert_response :success
  end

  test "should return unauthorized without session" do
    post books_url, params: { book: { title: "New Book", author_id: @author.id } }
    assert_response :unauthorized
  end
end
