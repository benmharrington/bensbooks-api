require "test_helper"
include Messages

class AuthorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @password = Faker::Internet.password(min_length: 8)
    @user = create(:user, password: @password, password_confirmation: @password)
  end

  test "should allow unauthenticated access to index" do
    get authors_url
    assert_response :success
  end

  test "should allow unauthenticated access to show" do
    author = create(:author)
    get author_url(author)
    assert_response :success
  end

  test "should display a list of books for an author" do
    author = create(:author)
    books = create_list(:book, 3, author: author)

    get books_url(author)
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal 3, json_response.length
    book_titles = books.map(&:title)
    json_response.each do |book|
      assert_includes book_titles, book["title"]
    end
  end

  test "should allow signed in user to create author" do
    sign_in_as(@user)

    post authors_url, params: { author: {
      name: "New Author",
      bio: "An author bio",
      full_name: "New Author Fullname",
      birthdate: "1970-01-01",
      deathdate: nil,
      birthplace: "Someplace",
      link: "http://example.com"
    } }
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal "New Author", json_response["name"]
  end

  test "should not allow creating author without session" do
    post authors_url, params: { author: {
      name: "New Author",
      bio: "An author bio",
      full_name: "New Author Fullname",
      birthdate: "1970-01-01",
      deathdate: nil,
      birthplace: "Someplace",
      link: "http://example.com"
    } }
    assert_response :unauthorized
  end

  test "should allow signed in user to update author" do
    sign_in_as(@user)
    author = create(:author)

    put author_url(author), params: { author: { bio: "Updated bio" } }
    assert_response :success

    author.reload
    assert_equal "Updated bio", author.bio
  end

  test "should allow signed in user to delete author" do
    sign_in_as(@user)
    author = create(:author)

    assert_difference("Author.count", -1) do
      delete author_url(author)
    end
    assert_response :success
  end

  test "author's deathdate should not be before birthdate" do
    sign_in_as(@user)
    author = create(:author, birthdate: "1970-01-01")

    put author_url(author), params: { author: { deathdate: "1960-01-01" } }
    assert_response :unprocessable_content

    json_response = JSON.parse(response.body)
    assert_includes json_response["errors"], "Deathdate #{Messages::VALIDATIONS[:deathdate_invalid]}"
  end

  test "author's link should be a valid URL" do
    sign_in_as(@user)
    author = create(:author)

    put author_url(author), params: { author: { link: "invalid-url" } }
    assert_response :unprocessable_content

    json_response = JSON.parse(response.body)
    assert_includes json_response["errors"], "Link #{Messages::VALIDATIONS[:url_invalid]}"
  end
end
