class Post < ApplicationRecord
  belongs_to :author
  enum :status, { draft: "draft", published: "published", deleted: "deleted" }, default: :draft, prefix: true
end
