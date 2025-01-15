# frozen_string_literal: true

class AuthorsController < ApplicationController
  before_action :find_author, only: %i[show update books destroy]
  allow_unauthenticated_access only: %i[ index show ]
  def index
    @authors = author.all
    render :index
  end

  def show
    if @author
      render :author
    else
      render json: { errors: [ "Author not found" ] }, status: :not_found
    end
  end

  def books
    @books = @author.books
    render :books
  end

  def update
    if @author.update(author_params)
      render :author
    else
      render json: { errors: @author.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create
    @author = author.new(author_params)
    if @author.save
      render :author, status: :ok
    else
      render json: { errors: @author.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @author.destroy
  end

  private

  def find_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name, :bio)
  end
end
