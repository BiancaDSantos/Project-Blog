class Api::V1::PostController < ApplicationController

  VALID_STATUSES = %w[draft published archived].freeze

  def index
    render json: Post.all
  end

  def show
    render json: Post.find(params[:id])
  end

  def create
    post_params = params.permit(:is_commenting_enabled, :status, :author_id)

    author = Author.find_by(id: post_params[:author_id])
    return render json: { error: "Autor não encontrado." }, status: :not_found unless author

    return render json: { error: "Status inválido." },
                  status: :unprocessable_entity unless VALID_STATUSES.include?(params[:status])

    post = author.posts.new(
      is_commenting_enabled: post_params[:is_commenting_enabled],
      status: post_params[:status]
    )

    return render json: { error: post.errors.full_messages }, status: :unprocessable_entity unless post.save

    render json: post, status: :created
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
  end

  def update
    post = Post.find_by(id: params[:id])
    return render json: { error: "Post não encontrado." }, status: :not_found unless post

    return render json: { error: "Status inválido." },
                  status: :unprocessable_entity unless VALID_STATUSES.include?(params[:status])

    if post.update(params.permit(:is_commenting_enabled, :status))
      render json: post, status: :ok
    else
      render json: { error: post.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
