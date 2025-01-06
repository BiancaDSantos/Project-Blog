class Api::V1::AuthorController < ApplicationController

  def index
    @authors = Author.all
    render json: @authors
  end

  def show
    render json: Author.find(params[:id])
  end

  def create
    author = Author.new(params.require(:author).permit(:name, :email, :senha))

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
    if author.update(params.require(:author).permit(:name, :email, :senha))
      render json: author, status: :ok
    else
      render json: { errors: author.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
