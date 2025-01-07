class BooksController < ApplicationController
  before_action :find_book, only: %i[show update]
  allow_unauthenticated_access only: %i[ index show ]
  def index
    @books = Book.all
  end

  def show
    render :book
  end

  def update
    if @book.update(book_params)
      render :book
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      render json: @book, status: :ok
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
  end

  private

  def find_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:name)
  end
end
