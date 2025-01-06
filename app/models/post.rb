class Post < ApplicationRecord
  belongs_to :author
  has_many :post_revisions
  enum :status, { draft: "draft", published: "published", deleted: "deleted" }, default: :draft, prefix: true

  def active_revision
    post_revisions.active.first
  end
end
