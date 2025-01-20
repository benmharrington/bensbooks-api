# frozen_string_literal: true

class SynopsesController < ApplicationController
  before_action :find_synopsis, only: %i[show update]
  # TODO: remove create once auth is added
  allow_unauthenticated_access only: %i[ index show create ]
  # TODO: validate length of content (once decided)
  def index
    @synopses = Synopsis.all
    render :index
  end

  def show
    if @synopsis
      render :synopsis
    else
      render json: { errors: [ "Synopsis not found" ] }, status: :not_found
    end
  end

  def update
    if @synopsis.update(synopsis_params)
      render :synopsis
    else
      render json: { errors: @synopsis.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create
    @book = Book.find(params[:book_id])
    @synopsis = @book.synopses.new(synopsis_params)
    if @synopsis.save
      render json: @synopsis, status: :ok
    else
      render json: { errors: @synopsis.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @synopsis.destroy
  end

  private

  def find_synopsis
    @synopsis = Synopsis.find(params[:id])
  end

  def synopsis_params
    params.require(:synopsis).permit(:content)
  end
end
