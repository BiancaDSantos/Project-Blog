class Api::V1::CommentController < ApplicationController

  def index
    post = Post.find(params[:post_id])
    comments = post.comments
    render json: comments, status: :ok
  end

  def create
    post = Post.find(params[:post_id])

    return render json: { errors: [ "Post não foi encontrado" ] }, status: :not_found unless post

    comment = post.comments.new(comment_params)

    return render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity unless comment.save

    render json: comment, status: :created
  end

  def destroy
    comment = Comment.find(params[:id])
    return render json: { errors: [ "Comentário não foi encontrado" ] }, status: :not_found unless comment
    comment.destroy
  end

  private

  def comment_params
    params.permit(:content, :author_id)
  end

end
