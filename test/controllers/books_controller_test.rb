require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
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

  test "should allow unauthenticated access to show" do
    get book_url(@book)
    assert_response :success
  end

  test "should allow user to update book details with valid session" do
    sign_in_as(@user)

    put book_url(@book), params: { book: { title: "Updated Title" } }
    assert_response :success

    @book.reload
    assert_equal "Updated Title", @book.title
  end

  test "should allow user to delete book with valid session" do
    sign_in_as(@user)

    assert_difference("Book.count", -1) do
      delete book_url(@book)
    end
    assert_response :no_content
    assert_not Book.exists?(@book.id)
    assert_raises(ActiveRecord::RecordNotFound) { @book.reload }
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
