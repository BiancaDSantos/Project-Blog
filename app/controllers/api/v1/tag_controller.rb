class Api::V1::TagController < ApplicationController

  def index
    render json: Tag.all
  end

  def show
    render json: Tag.find_by(params[:id])
  end

  def create
    tag = Tag.new(params.permit(:name))

    if tag.save
      render json: tag, status: :created
    else
      render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    tag = Tag.find_by(params[:id])
    tag.destroy
  end

  def update
    tag = Tag.find_by(params[:id])
    if tag.update(params.permit(:name))
      render json: tag, status: :ok
    else
      render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

end
