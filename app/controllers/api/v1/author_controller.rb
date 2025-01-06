class Api::V1::AuthorController < ApplicationController

  def index
    render json: Author.all
  end

  def show
    render json: Author.find(params[:id])
  end

  def create
    author = Author.new(params.permit(:name, :email, :password))

    if author.save
      render json: author, status: :created
    else
      render json: { errors: author.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    author = Author.find(params[:id])
    author.destroy
  end

  def update
    author = Author.find(params[:id])
    if author.update(params.permit(:name, :email, :password))
      render json: author, status: :ok
    else
      render json: { errors: author.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
