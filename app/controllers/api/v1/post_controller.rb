class Api::V1::PostController < ApplicationController
  VALID_STATUSES = %w[draft published archived].freeze
  PERMITTED_PARAMS = %i[is_commenting_enabled status author_id title content].freeze

  def index
    posts = Post.includes(:post_revisions).all
    render json: serialize_posts(posts)
  end

  def show
    render json: serialize_post(find_post(params[:id]))
  end

  def create
    author = find_author(params[:author_id])
    return if performed?

    return render json: { error: "Status inválido." },
                  status: :unprocessable_entity unless valid_status?(params[:status])

    post = author.posts.new(
      is_commenting_enabled: params[:is_commenting_enabled],
      status: params[:status]
    )
    return render json: { error: post.errors.full_messages }, status: :unprocessable_entity unless post.save

    post_revision = post.post_revisions.new(
      title: params[:title], content: params[:content], active_revision: true
    )

    return render json: { error: post_revision.errors.full_messages },
                  status: :unprocessable_entity unless post_revision.save

    tags_names = params[:tags] || []

    existing_tags = Tag.where(name: tags_names)
    non_existing_tags = tags_names - existing_tags.pluck(:name)

    return render json: { error: "ERRO: O post não foi associado com as tags informadas." },
                  status: :unprocessable_entity unless post_revision.tags << existing_tags

    additional_fields = [
      (non_existing_tags.any? ? { name: :missing_tags, value: non_existing_tags } : nil),
      { name: :author_post_quantity, value: author.posts.count }
    ].compact

    render json: serialize_post(post,
                                additional_fields: additional_fields), status: :created
  end

  def destroy
    post = find_post(params[:id])
    post&.destroy
  end

  def update
    post = find_post(params[:id])

    active_revision = post.active_revision

    return render json: { error: "Status inválido." },
                  status: :unprocessable_entity unless valid_status?(params[:status])

    return render json: { error: post.errors.full_messages },
                  status: :unprocessable_entity unless post.update(params.permit(:is_commenting_enabled, :status))

    if (params[:title] && params[:title] != active_revision.title) || (params[:content] && params[:content] != active_revision.content)
      post_revision = post.post_revisions.new(
        title: params[:title] || active_revision.title,
        content: params[:content] || active_revision.content,
        active_revision: true
      )
      return render json: { error: post_revision.errors.full_messages },
                    status: :unprocessable_entity unless post_revision.save

      post_revision.tags = active_revision.tags if active_revision.tags.any?

      active_revision.update(active_revision: false)
    end

    if params[:tags_to_add] || params[:tags_to_remove]
      tags_to_add = Tag.where(name: params[:tags_to_add] || [])
      tags_to_remove = Tag.where(name: params[:tags_to_remove] || [])

      active_revision = post.active_revision

      tags_to_add.each do |tag|
        tag_post = active_revision&.tag_posts&.find_or_initialize_by(tag: tag)
        tag_post&.update(active: true)
      end

      active_revision&.tag_posts&.where(tag: tags_to_remove)&.update_all(active: false)

      non_existing_tags_to_add = params[:tags_to_add] - tags_to_add.pluck(:name)
      non_existing_tags_to_remove = params[:tags_to_remove] - tags_to_remove.pluck(:name)
    end

    additional_fields = [
      (non_existing_tags_to_add&.any? ? { name: :non_existing_tags_to_add, value: non_existing_tags_to_add } : nil),
      (non_existing_tags_to_remove&.any? ? { name: :non_existing_tags_to_remove, value: non_existing_tags_to_remove } : nil)
    ].compact

    render json: serialize_post(post, additional_fields: additional_fields), status: :ok
  end

  private

  def serialize_posts(posts, include_revisions: false, additional_fields: [])
    posts.map do |post|
      serialize_post(post, include_revisions: include_revisions, additional_fields: additional_fields)
    end
  end

  def serialize_post(post, include_revisions: true, additional_fields: [])
    active_revision = post.active_revision

    result = {
      id: post.id,
      author: post.author.name,
      is_commenting_enabled: post.is_commenting_enabled,
      status: post.status,
      title: active_revision&.title,
      content: active_revision&.content,
      tags: active_revision&.tags&.pluck(:name),
      created_at: post.created_at,
      updated_at: post.updated_at,
      comments: post.comments&.map { |comment| { id: comment.id, content: comment.content, author: comment.author&.name } }
    }

    result[:revisions] = serialize_revisions(post.post_revisions) if include_revisions

    additional_fields.each do |field|
      key = field[:name]
      value = field[:value]
      result[key] = value
    end

    result
  end

  def serialize_revisions(revisions)
    revisions.map do |rev|
      {
        revision_id: rev.id,
        title: rev.title,
        content: rev.content,
        active_revision: rev.active_revision,
        tags: rev.tags&.pluck(:name),
        created_at: rev.created_at,
        updated_at: rev.updated_at
      }
    end
  end

  def valid_status?(status)
    VALID_STATUSES.include?(status)
  end

  def find_author(author_id)
    author = Author.find_by(id: author_id)
    render json: { error: "Autor não encontrado." }, status: :not_found unless author
    author
  end

  def find_post(post_id)
    post = Post.find_by(id: post_id)
    render json: { error: "Post não encontrado." }, status: :not_found unless post
    post
  end
end
