class Api::V1::PostController < ApplicationController

  VALID_STATUSES = %w[draft published archived].freeze

  def index
    posts = Post.includes(:post_revisions).all
    result = posts.map do |post|
      {
        id: post.id,
        author_id: post.author_id,
        is_commenting_enabled: post.is_commenting_enabled,
        status: post.status,
        active_revision: post.active_revision,
        created_at: post.created_at,
        updated_at: post.updated_at
      }
    end
    render json: result
  end

  def show
    render json: Post.find_by(id: params[:id]), include: :post_revisions
  end

  def create
    post_params = params.permit(:is_commenting_enabled, :status, :author_id, :title, :content)

    author = Author.find_by(id: post_params[:author_id])
    return render json: { error: "Autor não encontrado." }, status: :not_found unless author

    return render json: { error: "Status inválido." },
                  status: :unprocessable_entity unless VALID_STATUSES.include?(post_params[:status])

    post = author.posts.new(
      is_commenting_enabled: post_params[:is_commenting_enabled],
      status: post_params[:status]
    )

    return render json: { error: post.errors.full_messages }, status: :unprocessable_entity unless post.save

    post_revision = post.post_revisions.new(
      title: post_params[:title], content: post_params[:content], active_revision: true
    )

    return render json: { error: post_revision.errors.full_messages },
                  status: :unprocessable_entity unless post_revision.save

    render json: post, status: :created, include: :post_revisions
  end

  def destroy
    post = Post.find_by(id: params[:id])
    post.destroy
  end

  def update
    post = Post.find_by(id: params[:id])
    return render json: { error: "Post não encontrado." }, status: :not_found unless post

    post_params = params.permit(:is_commenting_enabled, :status, :author_id, :title, :content)

    return render json: { error: "Status inválido." },
                  status: :unprocessable_entity unless VALID_STATUSES.include?(post_params[:status])

    return render json: { error: post.errors.full_messages },
                  status: :unprocessable_entity unless post.update(params.permit(:is_commenting_enabled, :status))

    if post_params[:title] || post_params[:content]
      active_revision = post.active_revision

      post_revision = post.post_revisions.new(
        title: post_params[:title] || active_revision.title,
        content: post_params[:content] || active_revision.content,
        active_revision: true
      )
      return render json: { error: post_revision.errors.full_messages },
                    status: :unprocessable_entity unless post_revision.save

      return render json: { error: active_revision.errors.full_messages },
                    status: :unprocessable_entity unless active_revision.update(active_revision: false)
    end

    render json: post, status: :ok, include: :post_revisions
  end
end
