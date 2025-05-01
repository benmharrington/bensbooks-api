# frozen_string_literal: true

class SynopsesController < ApplicationController
  before_action :find_synopsis, only: %i[ show update destroy ]
  # TODO: validate length of content (once decided)
  def index
    @synopses = Synopsis.all
    render :index
  end

  def show
    render :synopsis
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
    head :no_content
  end

  private

  def find_synopsis
    @synopsis = Synopsis.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: [ "Synopsis not found" ] }, status: :not_found
  end

  def synopsis_params
    params.require(:synopsis).permit(:content, :book_id, :user_id)
  end
end
