class Post < ApplicationRecord
  belongs_to :author
  has_many :post_revisions
  has_many :tag_posts, through: :post_revisions
  has_many :tags, through: :tag_posts
  enum :status, { draft: "draft", published: "published", deleted: "deleted" }, default: :draft, prefix: true

  def active_revision
    post_revisions.active.first
  end
end
